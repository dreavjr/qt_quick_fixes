/*=====================================================================================================================
  Copyright 2022 Eduardo Valle

  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
  persons to whom the Software is furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
  Software.

  The Software is provided "as is", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, including but not limited to the
  warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or
  copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or
  otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.
======================================================================================================================*/
pragma Singleton
import QtQuick


QtObject {
    // --- UI dimensions
    readonly property int defaultWidth: Math.floor(
                                        Math.min( Screen.desktopAvailableWidth  * 0.875,
                                                  Screen.desktopAvailableHeight * 0.875,
                                                 (Screen.desktopAvailableWidth + Screen.desktopAvailableHeight)/6 ) )
    readonly property int defaultHeight: defaultWidth
    readonly property int spacing: 10
    readonly property int padding: 10
}
