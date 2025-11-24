import 'package:flutter/material.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/text_styles.dart';
import '../utils/colors.dart';
import '../services/openai_service.dart';
import '../extensions/loader_widget.dart';
import '../main.dart';
import '../extensions/shared_pref.dart';
import '../languageConfiguration/LanguageDataConstant.dart';

class EnhanceDescriptionDialog extends StatefulWidget {
  final String originalDescription;
  final Function(String) onSelect;

  const EnhanceDescriptionDialog({
    Key? key,
    required this.originalDescription,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<EnhanceDescriptionDialog> createState() =>
      _EnhanceDescriptionDialogState();
}

class _EnhanceDescriptionDialogState extends State<EnhanceDescriptionDialog> {
  Map<String, String>? options;
  bool isLoading = true;
  String? error;
  Map<String, bool> loadingStates = {
    'corrected': false,
    'enhanced': false,
    'withOpinion': false,
  };

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  String _getCurrentLanguageCode() {
    // Get language code from appStore or shared preferences
    String currentLangCode = appStore.selectedLanguage.isNotEmpty
        ? appStore.selectedLanguage
        : getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: 'en');

    // If empty, default to English
    if (currentLangCode.isEmpty) {
      currentLangCode = 'en';
    }

    return currentLangCode;
  }

  String _getLocalizedText(String english, String arabic) {
    final langCode = _getCurrentLanguageCode();
    return langCode == 'ar' ? arabic : english;
  }

  Future<void> _loadOptions() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final currentLangCode = _getCurrentLanguageCode();
      final openAIService = OpenAIService();
      final results = await openAIService.getAllOptions(
        widget.originalDescription,
        //currentLangCode,
      );

      setState(() {
        options = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      // Error will be shown in the dialog UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getLocalizedText('Enhance Description', 'تحسين الوصف'),
                  style: boldTextStyle(size: 20, color: primaryColor),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            20.height,
            if (isLoading)
              Container(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Loader(),
                      16.height,
                      Text(
                          _getLocalizedText(
                              'Generating enhanced descriptions...',
                              'جارٍ إنشاء الأوصاف المحسنة...'),
                          style: secondaryTextStyle()),
                    ],
                  ),
                ),
              )
            else if (error != null)
              Column(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  16.height,
                  Text('${_getLocalizedText("Error", "خطأ")}: $error',
                      style: secondaryTextStyle(color: Colors.red)),
                  16.height,
                  ElevatedButton(
                    onPressed: _loadOptions,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    child: Text(_getLocalizedText('Retry', 'إعادة المحاولة'),
                        style: boldTextStyle(color: Colors.white)),
                  ),
                ],
              )
            else if (options != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildOptionCard(
                        title: _getLocalizedText(
                            'Corrected (No Mistakes)', 'مصحح (بدون أخطاء)'),
                        subtitle: _getLocalizedText(
                            'Same context, no language errors',
                            'نفس السياق، بدون أخطاء لغوية'),
                        description: options!['corrected']!,
                        onSelect: () => _selectOption(options!['corrected']!),
                      ),
                      16.height,
                      _buildOptionCard(
                        title: _getLocalizedText('Enhanced', 'محسّن'),
                        subtitle: _getLocalizedText(
                            'Improved and polished', 'محسّن ومصقول'),
                        description: options!['enhanced']!,
                        onSelect: () => _selectOption(options!['enhanced']!),
                      ),
                      16.height,
                      _buildOptionCard(
                        title: _getLocalizedText('With Opinion', 'مع رأي'),
                        subtitle: _getLocalizedText(
                            'Professional real estate perspective',
                            'منظور عقاري احترافي'),
                        description: options!['withOpinion']!,
                        onSelect: () => _selectOption(options!['withOpinion']!),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onSelect,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: boldTextStyle(size: 16, color: primaryColor)),
          4.height,
          Text(subtitle, style: secondaryTextStyle(size: 12)),
          12.height,
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Text(
              description,
              style: secondaryTextStyle(),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          12.height,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSelect,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _getLocalizedText('Use This', 'استخدم هذا'),
                style: boldTextStyle(color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectOption(String selectedDescription) {
    widget.onSelect(selectedDescription);
    Navigator.pop(context);
  }
}
