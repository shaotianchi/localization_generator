# localization_generator
localization_generator

## Usage
* Add `LocalizationGenerator.sh` to your project's `Supporting Files`
* Add a `Run Script` in `Build Phases`, copy next script 

  ``` shell
  "${SRCROOT}/${PRODUCT_NAME}/LocalizationGenerator.sh"
  ```
* build project
* script will create `[ProjectName]String.h` and `[ProjectName]String.m` in your project folder

## Notice
You must name your `.string` file as `[ProjectName]Localization.string`
