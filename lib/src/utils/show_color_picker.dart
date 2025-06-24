// lib/src/utils/show_color_picker.dart

// flutter
import 'package:flutter/material.dart';

// external
import 'package:go_router/go_router.dart';

// core
import 'package:applimode_app/custom_settings.dart';

// utils
import 'package:applimode_app/src/utils/app_loacalizations_context.dart';
import 'package:applimode_app/src/utils/format.dart';
import 'package:applimode_app/src/utils/regex.dart';
import 'package:applimode_app/src/utils/safe_build_call.dart';

// English: Displays a dialog with a custom color picker.
// 한글: 사용자 정의 색상 선택기가 포함된 다이얼로그를 표시합니다.
Future<Color?> showColorPicker({
  required BuildContext context,
  Color? currentColor,
  List<Color>? colorPalettes,
}) async {
  return showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(context.loc.selectColor),
      contentPadding: const EdgeInsets.all(32),
      children: [
        CustomColorPicker(
          currentColor: currentColor,
          colorPalettes: colorPalettes,
        ),
      ],
    ),
  );
}

class CustomColorPicker extends StatefulWidget {
  const CustomColorPicker({
    super.key,
    this.currentColor, // English: The initially selected color, possibly with shade. / 한글: 초기에 선택된 색상 (쉐이딩 포함 가능).
    this.colorPalettes, // English: Optional list of predefined color palettes. / 한글: 선택적으로 제공되는 미리 정의된 색상 팔레트 목록.
  });

  final Color? currentColor;
  final List<Color>? colorPalettes;

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  final _directColorController = TextEditingController();
  // English: Position on the color spectrum slider (0.0 to 1.0).
  // 한글: 색상 스펙트럼 슬라이더의 위치 (0.0 ~ 1.0).
  double _colorSliderPosition = 0.5;
  // English: Position on the shade slider (0.0 black, 0.5 original, 1.0 white).
  // 한글: 쉐이드 슬라이더의 위치 (0.0 검은색, 0.5 원본색, 1.0 흰색).
  double _shadeSliderPosition = 0.5;
  // English: The pure color selected from the spectrum (no shading).
  // 한글: 스펙트럼에서 선택된 순수 색상 (쉐이딩 없음).
  Color _currentColor = Format.hexStringToColor(spareMainColor);
  // English: The final color after applying shade to _currentColor.
  // 한글: _currentColor에 쉐이드를 적용한 최종 색상.
  Color _shadedColor = Format.hexStringToColor(spareMainColor);
  List<Color> _basicColorPalettes = colorPickerBasicPalettes;

  // English: Flag to prevent setState calls after dispose.
  // 한글: dispose 후 setState 호출을 방지하기 위한 플래그.
  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    if (widget.currentColor != null) {
      // English: If an initial color is provided (widget.currentColor),
      // which is assumed to be an already shaded color,
      // we reverse-calculate the original spectrum color (_currentColor),
      // its position on the color slider (_colorSliderPosition),
      // and the shade slider position (_shadeSliderPosition).
      // 한글: 만약 widget.currentColor (이미 쉐이딩된 색상으로 간주)가 제공되면,
      // 해당 색상으로부터 원래의 스펙트럼 색상(_currentColor),
      // 색상 슬라이더 위치(_colorSliderPosition),
      // 그리고 쉐이드 슬라이더 위치(_shadeSliderPosition)를 역산합니다.
      final analysisResult = _findSpectrumColorAndShade(widget.currentColor!);
      _currentColor = analysisResult.spectrumColor;
      _colorSliderPosition = analysisResult.colorSliderPosition;
      _shadeSliderPosition = analysisResult.shadeSliderPosition;
      // English: _shadedColor should ideally be widget.currentColor.
      // Using widget.currentColor directly minimizes potential minor discrepancies from reverse calculation.
      // 한글: _shadedColor는 widget.currentColor와 거의 동일해야 합니다.
      // widget.currentColor를 직접 사용하면 역산 과정에서의 미세한 오차를 줄일 수 있습니다.
      _shadedColor = widget.currentColor!;
    } else {
      // English: Default initialization if no current color is provided.
      // 한글: 현재 색상이 제공되지 않은 경우 기본값으로 초기화합니다.
      _colorSliderPosition = 0.5;
      _currentColor = _getSpectrumColorAtPosition(_colorSliderPosition);
      _shadeSliderPosition = 0.5;
      _shadedColor = _calculateShadedColor(_currentColor, _shadeSliderPosition);
    }
    _directColorController.text = Format.colorToHexString(_shadedColor);
    _basicColorPalettes = widget.colorPalettes ?? colorPickerBasicPalettes;
  }

  @override
  void dispose() {
    _isCancelled = true;
    _directColorController.dispose();
    super.dispose();
  }

  // English: Safely calls setState only if the widget is mounted and not cancelled.
  // 한글: 위젯이 마운트되어 있고 취소되지 않은 경우에만 안전하게 setState를 호출합니다.
  void _safeSetState([VoidCallback? callback]) {
    if (_isCancelled) return;
    if (mounted) {
      safeBuildCall(() => setState(() {
            callback?.call();
          }));
    }
  }

  // English: Calculates the shaded color based on a base color and a shade position.
  // Position: 0.0 = black, 0.5 = baseColor, 1.0 = white.
  // Assumes Color.from and color components (r,g,b) operate on doubles in 0.0-1.0 range.
  // 한글: 기본 색상과 쉐이드 위치를 기반으로 쉐이딩된 색상을 계산합니다.
  // 위치: 0.0 = 검은색, 0.5 = 기본 색상, 1.0 = 흰색.
  // Color.from 및 색상 구성 요소(r,g,b)가 0.0-1.0 범위의 double 값으로 작동한다고 가정합니다.
  Color _calculateShadedColor(Color baseColor, double position) {
    try {
      // English: Alpha is always 1.0 (opaque). Assumes Color.from takes alpha as double 0.0-1.0.
      // 한글: 알파 값은 항상 1.0 (불투명)입니다. Color.from이 알파를 0.0-1.0의 double 값으로 받는다고 가정합니다.
      final double alpha = 1.0;

      if (position == 0.5) {
        return baseColor;
      }

      double r, g, b;
      if (position > 0.5) {
        // English: Lighten towards white.
        // 한글: 흰색으로 밝게 합니다.
        final factor = (position - 0.5) / 0.5;
        r = baseColor.r + (1.0 - baseColor.r) * factor;
        g = baseColor.g + (1.0 - baseColor.g) * factor;
        b = baseColor.b + (1.0 - baseColor.b) * factor;
      } else {
        // English: Darken towards black.
        // 한글: 검은색으로 어둡게 합니다.
        final factor = position / 0.5;
        r = baseColor.r * factor;
        g = baseColor.g * factor;
        b = baseColor.b * factor;
      }
      return Color.from(
        alpha: alpha,
        red: r.clamp(0.0, 1.0),
        green: g.clamp(0.0, 1.0),
        blue: b.clamp(0.0, 1.0),
      );
    } catch (e) {
      debugPrint(
          'CustomColorPicker-_calculateShadedColor-error: ${e.toString()}');
      return Format.hexStringToColor(spareMainColor);
    }
  }

  // English: Calculates the color on the spectrum at a given slider position.
  // Interpolates between colors in `colorPickerColors`.
  // Assumes Color.from and color components (r,g,b) operate on doubles in 0.0-1.0 range.
  // 한글: 주어진 슬라이더 위치에서 스펙트럼 상의 색상을 계산합니다.
  // `colorPickerColors`의 색상들 사이를 보간합니다.
  // Color.from 및 색상 구성 요소(r,g,b)가 0.0-1.0 범위의 double 값으로 작동한다고 가정합니다.
  Color _getSpectrumColorAtPosition(double position) {
    position = position.clamp(0.0, 1.0);
    if (colorPickerColors.isEmpty) {
      debugPrint(
          'CustomColorPicker-_getSpectrumColorAtPosition-error: colorPickerColors is empty');
      // English: Default to a mid-gray if colorPickerColors is empty.
      // 한글: colorPickerColors가 비어 있으면 기본 중간 회색으로 설정합니다.
      return const Color.from(alpha: 1.0, red: 0.5, green: 0.5, blue: 0.5);
    }
    if (colorPickerColors.length == 1) {
      return colorPickerColors.first;
    }

    try {
      double positionInColorArray = position * (colorPickerColors.length - 1);
      int index = positionInColorArray.floor();
      double remainder = positionInColorArray - index;

      if (index >= colorPickerColors.length - 1) {
        return colorPickerColors.last;
      }

      final Color c1 = colorPickerColors[index];
      final Color c2 = colorPickerColors[index + 1];

      // English: Linear interpolation for each color component.
      // 한글: 각 색상 구성 요소에 대한 선형 보간.
      double redValue = c1.r + (c2.r - c1.r) * remainder;
      double greenValue = c1.g + (c2.g - c1.g) * remainder;
      double blueValue = c1.b + (c2.b - c1.b) * remainder;

      return Color.from(
          alpha: 1.0,
          red: redValue.clamp(0.0, 1.0),
          green: greenValue.clamp(0.0, 1.0),
          blue: blueValue.clamp(0.0, 1.0));
    } catch (e) {
      debugPrint(
          'CustomColorPicker-_getSpectrumColorAtPosition-error: ${e.toString()}');
      return Format.hexStringToColor(spareMainColor);
    }
  }

  // English: Finds the closest position on the color spectrum slider for a given target (pure spectrum) color.
  // 한글: 주어진 대상 (순수 스펙트럼) 색상에 대해 색상 스펙트럼 슬라이더에서 가장 가까운 위치를 찾습니다.
  double _findColorSliderPositionForColor(Color targetColor) {
    if (colorPickerColors.isEmpty) {
      debugPrint(
          'CustomColorPicker-_findColorSliderPositionForColor-error: colorPickerColors is empty');
      return 0.5;
    }
    if (colorPickerColors.length == 1) {
      // English: Check for equality with small tolerance for floating point comparison.
      // 한글: 부동 소수점 비교를 위해 작은 허용 오차로 동일성 확인.
      bool rSame = (targetColor.r - colorPickerColors.first.r).abs() < 1e-5;
      bool gSame = (targetColor.g - colorPickerColors.first.g).abs() < 1e-5;
      bool bSame = (targetColor.b - colorPickerColors.first.b).abs() < 1e-5;
      return (rSame && gSame && bSame) ? 0.0 : 0.5;
    }

    final double tR = targetColor.r;
    final double tG = targetColor.g;
    final double tB = targetColor.b;

    double bestPosition = 0.0;
    double minDifference = double.infinity;
    // English: Number of steps for searching; higher means more precision but more computation.
    // 한글: 검색 단계 수; 높을수록 정밀도가 높아지지만 계산량이 증가합니다.
    const int steps = 256;

    for (int i = 0; i <= steps; i++) {
      double currentSliderPos = i / steps.toDouble();
      Color spectrumColorAtPos = _getSpectrumColorAtPosition(currentSliderPos);

      final double calcR = spectrumColorAtPos.r;
      final double calcG = spectrumColorAtPos.g;
      final double calcB = spectrumColorAtPos.b;

      // English: Calculate squared Euclidean distance in RGB space.
      // 한글: RGB 공간에서 유클리드 거리의 제곱을 계산합니다.
      final double diff = (tR - calcR) * (tR - calcR) +
          (tG - calcG) * (tG - calcG) +
          (tB - calcB) * (tB - calcB);

      if (diff < minDifference) {
        minDifference = diff;
        bestPosition = currentSliderPos;
      }
      // English: If a very close match is found, return early.
      // 한글: 매우 근접한 일치 항목을 찾으면 일찍 반환합니다.
      if (diff < 1e-9) {
        return bestPosition.clamp(0.0, 1.0);
      }
    }
    return bestPosition.clamp(0.0, 1.0);
  }

  // English: Analyzes a target shaded color to find its original spectrum color,
  // the corresponding color slider position, and the shade slider position.
  // 한글: 대상 쉐이딩된 색상을 분석하여 원래의 스펙트럼 색상,
  // 해당 색상 슬라이더 위치 및 쉐이드 슬라이더 위치를 찾습니다.
  SpectrumColorAnalysisResult _findSpectrumColorAndShade(
      Color targetShadedColor) {
    if (colorPickerColors.isEmpty) {
      debugPrint('_findSpectrumColorAndShade: colorPickerColors is empty');
      return SpectrumColorAnalysisResult(
        spectrumColor: Format.hexStringToColor(spareMainColor),
        colorSliderPosition: 0.5,
        shadeSliderPosition: 0.5,
      );
    }

    Color bestSpectrumColor = _getSpectrumColorAtPosition(0.0);
    double bestColorSliderPosition = 0.0;
    double bestShadeSliderPosition = 0.5;
    double minDifference = double.infinity;

    // English: Search precision. Increasing these improves accuracy but costs more computation.
    // 한글: 탐색 정밀도. 이 값을 늘리면 정확도가 높아지지만 계산량이 증가합니다.
    const int spectrumSteps = 32; // Default 64 / 기본값 64
    const int shadeSteps = 32; // Default 64 / 기본값 64

    for (int i = 0; i <= spectrumSteps; i++) {
      double currentSpectrumPos = i / spectrumSteps.toDouble();
      Color candidateSpectrumColor =
          _getSpectrumColorAtPosition(currentSpectrumPos);

      for (int j = 0; j <= shadeSteps; j++) {
        double currentShadePos = j / shadeSteps.toDouble();
        Color calculatedShadedColor =
            _calculateShadedColor(candidateSpectrumColor, currentShadePos);

        // English: Calculate color difference (squared Euclidean distance in RGB).
        // 한글: 색상 차이 계산 (RGB 공간에서의 유클리드 거리 제곱).
        final double rDiff = targetShadedColor.r - calculatedShadedColor.r;
        final double gDiff = targetShadedColor.g - calculatedShadedColor.g;
        final double bDiff = targetShadedColor.b - calculatedShadedColor.b;
        final double currentDiff =
            rDiff * rDiff + gDiff * gDiff + bDiff * bDiff;

        if (currentDiff < minDifference) {
          minDifference = currentDiff;
          bestSpectrumColor = candidateSpectrumColor;
          bestColorSliderPosition = currentSpectrumPos;
          bestShadeSliderPosition = currentShadePos;
        }

        // English: Optimization: stop search if difference is very small (experimentally tuned threshold).
        // 한글: 최적화: 차이가 매우 작으면 검색 중단 (실험적으로 조정된 임계값).
        if (currentDiff < 1e-9) {
          return SpectrumColorAnalysisResult(
            spectrumColor: bestSpectrumColor,
            colorSliderPosition: bestColorSliderPosition.clamp(0.0, 1.0),
            shadeSliderPosition: bestShadeSliderPosition.clamp(0.0, 1.0),
          );
        }
      }
    }

    return SpectrumColorAnalysisResult(
      spectrumColor: bestSpectrumColor,
      colorSliderPosition: bestColorSliderPosition.clamp(0.0, 1.0),
      shadeSliderPosition: bestShadeSliderPosition.clamp(0.0, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _basicColorPalettes.take(5).map((color) {
            return InkWell(
              onTap: () {
                // English: When a palette color is tapped:
                // The current logic treats the palette color as a pure spectrum color (_currentColor)
                // and sets the shade to neutral (0.5).
                // An alternative (commented out in original code thoughts) would be to treat the palette color
                // as a potentially pre-shaded color and use _findSpectrumColorAndShade to analyze it.
                // 한글: 팔레트 색상 탭 시:
                // 현재 로직은 팔레트 색상을 순수 스펙트럼 색상(_currentColor)으로 취급하고,
                // 쉐이드를 중간(0.5)으로 설정합니다.
                // (원본 코드 생각에 주석 처리된) 대안으로는 팔레트 색상을 이미 쉐이딩된 색상으로 간주하고
                // _findSpectrumColorAndShade를 사용하여 분석하는 방법이 있습니다.
                _currentColor =
                    color; // Treat palette color as pure spectrum color. / 팔레트 색상을 순수 스펙트럼 색상으로 취급.
                _colorSliderPosition =
                    _findColorSliderPositionForColor(_currentColor);
                _shadeSliderPosition =
                    0.5; // Reset shade to neutral. / 쉐이드를 중간값으로 재설정.
                _shadedColor =
                    _calculateShadedColor(_currentColor, _shadeSliderPosition);

                _directColorController.text =
                    Format.colorToHexString(_shadedColor);
                _safeSetState();
              },
              child: Container(
                width: 40,
                height: 40,
                color: color,
              ),
            );
          }).toList(),
        ),
        if (_basicColorPalettes.length > 5) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _basicColorPalettes.skip(5).take(5).map((color) {
              return InkWell(
                onTap: () {
                  // English: Same logic as above for the second row of palettes.
                  // 한글: 위와 동일한 로직 (두 번째 팔레트 행).
                  _currentColor = color;
                  _colorSliderPosition =
                      _findColorSliderPositionForColor(_currentColor);
                  _shadeSliderPosition = 0.5;
                  _shadedColor = _calculateShadedColor(
                      _currentColor, _shadeSliderPosition);
                  _directColorController.text =
                      Format.colorToHexString(_shadedColor);
                  _safeSetState();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  color: color,
                ),
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: 32),
        // English: Color spectrum slider.
        // 한글: 색상 스펙트럼 슬라이더.
        Container(
          height: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(colors: colorPickerColors),
          ),
          child: Slider(
            value: _colorSliderPosition,
            onChanged: (value) {
              _colorSliderPosition = value;
              _currentColor = _getSpectrumColorAtPosition(_colorSliderPosition);
              _shadedColor =
                  _calculateShadedColor(_currentColor, _shadeSliderPosition);
              _directColorController.text =
                  Format.colorToHexString(_shadedColor);
              _safeSetState();
            },
            activeColor: Colors.transparent,
            inactiveColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 32),
        // English: Shade slider (black to current color to white).
        // 한글: 쉐이드 슬라이더 (검은색에서 현재 색상을 거쳐 흰색으로).
        Container(
          height: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: [
              const Color.from(
                  alpha: 1.0, red: 0.0, green: 0.0, blue: 0.0) /* Black */,
              _currentColor, // English: Current pure spectrum color. / 한글: 현재 순수 스펙트럼 색상.
              const Color.from(
                  alpha: 1.0, red: 1.0, green: 1.0, blue: 1.0) /* White */
            ]),
          ),
          child: Slider(
            value: _shadeSliderPosition,
            onChanged: (value) {
              _shadeSliderPosition = value;
              _shadedColor =
                  _calculateShadedColor(_currentColor, _shadeSliderPosition);
              _directColorController.text =
                  Format.colorToHexString(_shadedColor);
              _safeSetState();
            },
            activeColor: Colors.transparent,
            inactiveColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.currentColor != null) ...[
                // English: Display initially provided color.
                // 한글: 초기에 제공된 색상 표시.
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: widget.currentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_right_alt),
                const SizedBox(width: 8),
              ],
              // English: Display currently selected/calculated final color.
              // 한글: 현재 선택/계산된 최종 색상 표시.
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: _shadedColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 120,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: TextFormField(
                    controller: _directColorController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixText: '#',
                    ),
                    maxLength: 6,
                    validator: (value) {
                      if (value == null ||
                          value.trim().length != 6 ||
                          !Regex.hexColorRegex.hasMatch(value)) {
                        return context.loc.enterValidColor;
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    autocorrect: false,
                    enableSuggestions: false,
                    onChanged: (value) {
                      if (value.trim().length == 6 &&
                          Regex.hexColorRegex.hasMatch(value)) {
                        final newColorFromHex = Format.hexStringToColor(value);

                        // English: When the hex input changes and is valid:
                        // Treat the user-input hex color as the final shaded color.
                        // Then, reverse-calculate the corresponding spectrum color (_currentColor),
                        // color slider position, and shade slider position using _findSpectrumColorAndShade.
                        // 한글: Hex 입력값이 변경되고 유효할 때:
                        // 사용자가 입력한 Hex 색상을 최종 쉐이딩된 색상으로 간주합니다.
                        // 그런 다음 _findSpectrumColorAndShade를 사용하여 해당하는
                        // 스펙트럼 색상(_currentColor), 색상 슬라이더 위치, 쉐이드 슬라이더 위치를 역산합니다.
                        _shadedColor = newColorFromHex;
                        final analysis =
                            _findSpectrumColorAndShade(_shadedColor);
                        _currentColor = analysis.spectrumColor;
                        _colorSliderPosition = analysis.colorSliderPosition;
                        _shadeSliderPosition = analysis.shadeSliderPosition;

                        _safeSetState(() {
                          // English: Normalize the hex input in the text field (e.g., to uppercase).
                          // This ensures consistency if Format.colorToHexString produces a canonical form.
                          // 한글: Hex 입력 필드의 값을 정규화합니다 (예: 대문자로).
                          // Format.colorToHexString이 표준 형식을 생성하는 경우 일관성을 보장합니다.
                          _directColorController.text =
                              Format.colorToHexString(newColorFromHex);
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                context.pop(
                    null); // English: Cancel and return no color. / 한글: 취소하고 색상 없이 반환.
              },
              child: Text(context.loc.cancel),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                context.pop(
                    _shadedColor); // English: Confirm and return the selected color. / 한글: 확인하고 선택된 색상 반환.
              },
              child: Text(context.loc.ok),
            ),
          ],
        ),
      ],
    );
  }
}

// English: Holds the result of analyzing a shaded color to find its spectrum and shade components.
// 한글: 쉐이딩된 색상을 분석하여 스펙트럼 및 쉐이드 구성 요소를 찾은 결과를 저장합니다.
class SpectrumColorAnalysisResult {
  // English: The reverse-calculated original color on the spectrum.
  // 한글: 역산된 스펙트럼 상의 원본 색상.
  final Color spectrumColor;
  // English: The slider position for the spectrumColor.
  // 한글: 해당 스펙트럼 색상의 슬라이더 위치.
  final double colorSliderPosition;
  // English: The reverse-calculated shade slider position.
  // 한글: 역산된 쉐이드 슬라이더 위치.
  final double shadeSliderPosition;

  SpectrumColorAnalysisResult({
    required this.spectrumColor,
    required this.colorSliderPosition,
    required this.shadeSliderPosition,
  });
}

// English: List of colors defining the main color spectrum slider.
// Assumes Color.from takes RGB components as doubles in the 0.0-1.0 range.
// 한글: 메인 색상 스펙트럼 슬라이더를 정의하는 색상 목록입니다.
// Color.from이 RGB 구성 요소를 0.0-1.0 범위의 double 값으로 받는다고 가정합니다.
const List<Color> colorPickerColors = [
  Color.from(alpha: 1.0, red: 0.0, green: 0.0, blue: 0.0), // Black / 검은색
  Color.from(alpha: 1.0, red: 1.0, green: 0.0, blue: 0.0), // Red / 빨간색
  Color.from(alpha: 1.0, red: 1.0, green: 0.5, blue: 0.0), // Orange / 주황색
  Color.from(alpha: 1.0, red: 1.0, green: 1.0, blue: 0.0), // Yellow / 노란색
  Color.from(alpha: 1.0, red: 0.0, green: 1.0, blue: 0.0), // Green / 초록색
  Color.from(alpha: 1.0, red: 0.0, green: 1.0, blue: 1.0), // Cyan / 청록색
  Color.from(alpha: 1.0, red: 0.0, green: 0.0, blue: 1.0), // Blue / 파란색
  Color.from(alpha: 1.0, red: 0.5, green: 0.0, blue: 1.0), // Purple / 보라색
  Color.from(alpha: 1.0, red: 1.0, green: 0.0, blue: 1.0), // Magenta / 자홍색
  Color.from(alpha: 1.0, red: 1.0, green: 1.0, blue: 1.0), // White / 흰색
];
