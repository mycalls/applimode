import 'dart:async';
import 'dart:js_interop'; // Use dart:js_interop for modern web interop

import 'package:flutter/services.dart'; // For PlatformException
import 'package:image_picker/image_picker.dart'; // For XFile (to easily read bytes from Blob URL)
// Make sure you have the 'web' package dependency in your pubspec.yaml
import 'package:web/web.dart' as web;
import 'package:applimode_app/src/utils/web_image_compress/wic_stub.dart';

/// Changes the quality of an image loaded from a URL and returns the result as bytes.
///
/// The image dimensions (width and height) are preserved.
///
/// - [imageUrl]: The URL of the image to process.
/// - [quality]: The desired quality factor (0-100). 100 means highest quality,
///   0 means lowest quality/highest compression. Applies mainly to lossy formats like JPEG.
/// - [outputMimeType]: The desired output MIME type (e.g., 'image/jpeg', 'image/png', 'image/webp').
///   Defaults to 'image/jpeg'. Note that quality parameter might have no effect for lossless formats like PNG.
///
/// Returns a [Future] completing with the [Uint8List] of the image data
/// with the adjusted quality.
///
/// Throws a [PlatformException] if the image cannot be loaded or processed.

WicStub getInstance() => WicWeb();

class WicWeb implements WicStub {
  WicWeb();

  @override
  Future<Uint8List> changeImageQuality({
    required String imageUrl,
    required int quality,
    int maxWidthThreshold = 1080,
    String outputMimeType =
        'image/jpeg', // Default to JPEG as quality is usually for lossy formats
  }) async {
    // Ensure quality is within the valid range (0-100)
    final clampedQuality = quality.clamp(0, 100);

    final completer = Completer<web.Blob>();

    // 1. Create an HTML Image element
    final img = web.document.createElement('img') as web.HTMLImageElement;

    // 2. Set up listeners for load and error events *before* setting src
    // Use JSExported closures for event listeners with dart:js_interop
    final onLoadCompleter = Completer<void>();
    final onErrorCompleter = Completer<web.Event>();

    img.onLoad.listen((web.Event event) {
      if (!onLoadCompleter.isCompleted && !onErrorCompleter.isCompleted) {
        onLoadCompleter.complete();
      }
    });

    img.onError.listen((web.Event event) {
      if (!onLoadCompleter.isCompleted && !onErrorCompleter.isCompleted) {
        // The event itself might not have detailed error info,
        // but indicates loading failure.
        onErrorCompleter.complete(event);
      }
    });

    // 3. Set image source and CORS attribute (important for canvas security)
    img.crossOrigin =
        'Anonymous'; // Allow loading cross-origin images if server permits
    img.src = imageUrl;

    try {
      // 4. Wait for the image to load or fail
      await Future.any([onLoadCompleter.future, onErrorCompleter.future]);

      if (onErrorCompleter.isCompleted) {
        throw PlatformException(
          code: 'IMAGE_LOAD_ERROR',
          message: 'Failed to load image from URL: $imageUrl',
          details: 'Check browser console for more details.',
        );
      }

      // 5. Image loaded successfully, get original dimensions
      final int originalWidth = img.naturalWidth;
      final int originalHeight = img.naturalHeight;

      int targetWidth;
      int targetHeight;

      // 6. Determine target dimensions based on the width threshold
      if (originalWidth > maxWidthThreshold) {
        // Calculate aspect ratio
        final double aspectRatio = originalHeight / originalWidth;
        // Set target width to the threshold
        targetWidth = maxWidthThreshold;
        // Calculate corresponding height, rounding to the nearest pixel
        targetHeight = (targetWidth * aspectRatio).round();
      } else {
        // Use original dimensions if width is not greater than the threshold
        targetWidth = originalWidth;
        targetHeight = originalHeight;
      }

      // 7. Create canvas and context
      final canvas =
          web.document.createElement('canvas') as web.HTMLCanvasElement;
      final ctx = canvas.getContext('2d')! as web.CanvasRenderingContext2D;

      // 8. Set canvas dimensions to the target size
      canvas.width = targetWidth;
      canvas.height = targetHeight;

      // 9. Draw the loaded image onto the canvas, scaling it to the target dimensions
      // The drawImage method scales the source image (img) to fit the destination
      // rectangle (0, 0, targetWidth, targetHeight) on the canvas.
      ctx.drawImage(img, 0, 0, targetWidth.toDouble(), targetHeight.toDouble());

      // 10. Export the canvas content to a Blob with specified quality
      // canvas.toBlob requires a callback function.
      // We use the completer to bridge the callback to async/await.
      canvas.toBlob(
        (web.Blob? blob) {
          if (blob != null) {
            if (!completer.isCompleted) completer.complete(blob);
          } else {
            if (!completer.isCompleted) {
              completer.completeError(
                PlatformException(
                  code: 'CANVAS_TOBLOB_FAILED',
                  message: 'Failed to convert canvas to Blob.',
                  details:
                      'Output MIME type: $outputMimeType, Quality: $clampedQuality',
                ),
              );
            }
          }
        }.toJS, // Convert Dart closure to JS function
        outputMimeType, // Convert Dart String to JS String
        (clampedQuality / 100.0).toJS, // Quality must be between 0.0 and 1.0
      );
    } catch (e, s) {
      // Catch any synchronous errors during setup or potential exceptions
      // from the loading phase if not caught by onError listener logic.
      if (!completer.isCompleted) {
        completer.completeError(
          PlatformException(
            code: e is PlatformException ? e.code : 'PROCESSING_ERROR',
            message:
                e is PlatformException ? e.message : 'Error processing image.',
            details: e.toString(),
            stacktrace: s.toString(),
          ),
          s,
        );
      }
    }

    // 11. Wait for the Blob to be created
    try {
      final blob = await completer.future;

      // 10. Convert Blob to Uint8List using an Object URL and XFile
      // This pattern is borrowed from your video code and works well.
      final objectUrl = web.URL.createObjectURL(blob);
      // Use XFile to easily read bytes from the temporary Object URL
      final file = XFile(objectUrl, mimeType: blob.type);
      final bytes = await file.readAsBytes();
      // Revoke the Object URL to free up resources
      web.URL.revokeObjectURL(objectUrl);

      return bytes;
    } catch (e, s) {
      // Handle errors during Blob creation or conversion to bytes
      throw PlatformException(
        code: e is PlatformException ? e.code : 'BLOB_CONVERSION_ERROR',
        message: e is PlatformException
            ? e.message
            : 'Failed to convert Blob to bytes.',
        details: e.toString(),
        stacktrace: s.toString(),
      );
    }
  }
}
