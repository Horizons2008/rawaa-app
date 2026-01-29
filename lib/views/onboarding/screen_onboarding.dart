import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/onboarding_controller.dart';
import 'package:rawaa_app/my_widgets/custom_text.dart';
import 'package:rawaa_app/my_widgets/space_ver.dart';
import 'package:rawaa_app/styles/constants.dart';

class ScreenOnboarding extends StatelessWidget {
  const ScreenOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());
    return Scaffold(
      body: GetBuilder<OnboardingController>(
        builder: (controller) {
          return SafeArea(
            child: Column(
              children: [
                // Skip button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => controller.completeOnboarding(),
                      child: CustomText(
                        text: 'skip'.tr,
                        size: 16,
                        weight: FontWeight.w500,
                        coul: Colors.grey[600] ?? Colors.grey,
                      ),
                    ),
                  ),
                ),

                // PageView for slides
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: (index) {
                      controller.currentPage = index;
                      controller.update();
                    },
                    itemCount: controller.onboardingData.length,
                    itemBuilder: (context, index) {
                      return _buildOnboardingSlide(
                        controller.onboardingData[index],
                      );
                    },
                  ),
                ),

                // Page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.onboardingData.length,
                    (index) =>
                        _buildPageIndicator(index == controller.currentPage),
                  ),
                ),

                SpaceV(h: 30),

                // Navigation buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button (only show if not on first page)
                      if (controller.currentPage > 0)
                        TextButton(
                          onPressed: () {
                            controller.pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: CustomText(
                            text: 'back'.tr,
                            size: 16,
                            weight: FontWeight.w500,
                            coul: Constants.primaryColor,
                          ),
                        )
                      else
                        const SizedBox(width: 80),

                      // Next/Done button
                      ElevatedButton(
                        onPressed: () {
                          if (controller.currentPage ==
                              controller.onboardingData.length - 1) {
                            controller.completeOnboarding();
                          } else {
                            controller.pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: CustomText(
                          text:
                              controller.currentPage ==
                                  controller.onboardingData.length - 1
                              ? 'get_started'.tr
                              : 'next'.tr,
                          size: 16,
                          weight: FontWeight.w600,
                          coul: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                SpaceV(h: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOnboardingSlide(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image/Icon
          Container(
            height: 280,
            width: 280,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 120, color: data.color),
          ),

          SpaceV(h: 60),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          SpaceV(h: 20),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600] ?? Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? Constants.primaryColor
            : Colors.grey[300] ?? Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
