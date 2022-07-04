# r_border

A Flutter box border expand.Support gradient, dotted line and other you want.

## How to use?

```dart
          Container(
              decoration: const BoxDecoration(
                border: RBorder(
                  top: RGradientLineBorderSide(
                    width: 2,
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.red,
                      ],
                    ),
                  ),
                  right: RGradientLineBorderSide(
                    width: 2,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.red,
                        Colors.green,
                      ],
                    ),
                  ),
                  bottom: RGradientLineBorderSide(
                    width: 2,
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        Colors.green,
                        Colors.blue,
                      ],
                    ),
                  ),
                  left: RGradientLineBorderSide(
                    width: 2,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.blue,
                      ],
                    ),
                  ),
                ),
              ),
              child: const Text(
                'You have pushed the button this many times:',
              ),
            )
```

## LICENSE

    Copyright 2021 The r_upgrade_ui Project Authors

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
