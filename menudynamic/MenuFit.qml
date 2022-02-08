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

// The auto-sizing code for QML native menus is adapted from this blog post by Martin Hoeher:
// https://martin.rpdev.net/2018/03/13/qt-quick-controls-2-automatically-set-the-width-of-menus.html
// who has kindly released his solution to public domain.

import QtQuick 6.2
import QtQuick.Controls 6.2

Menu {
    width: {
        let maxWidth = 0;
        let maxPadding = 0;
        for (let i=0; i<count; i++) {
            let item = itemAt(i)
            maxWidth = Math.max(maxWidth, item.contentItem.implicitWidth)
            maxPadding = Math.max(maxPadding, item.padding)
        }
        return maxWidth + 2 * maxPadding
    }
}
