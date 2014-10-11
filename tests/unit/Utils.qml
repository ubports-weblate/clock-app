/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtTest 1.0
import QtQuick 2.3
import Ubuntu.Test 1.0

/*
 Utils.qml includes a set of commonly used test functions like pressing header
 buttons and helps reduce code duplication.

 Usage:
        Utils {
            id: testUtils
        }

        UbuntuTestCase {
            id: sampleTest
            name: "SampleTest"

            when: windowShown

            function initTestCase() {
               header = findChild(mainView, "MainView_Header")
               backButton = findChild(alarmTest.header, "customBackButton")
            }

            function test_something() {
              testUtils._pressHeaderButton(header, "addAlarmAction")
            }
       }
*/

UbuntuTestCase {
    id: testUtils

    function pressHeaderButton(header, objectName) {
        var headerButton = findChild(header, objectName + "_header_button")
        mouseClick(headerButton, centerOf(headerButton).x, centerOf(headerButton).y)
    }

    function pressButton(objectName) {
        mouseClick(objectName, centerOf(objectName).x, centerOf(objectName).y)
    }

    function getPage(pageStack, objectName) {
        var page = findChild(pageStack, objectName)
        waitForRendering(page)
        return page
    }

    function swipeToDeleteItem(item)
    {
        var startX = item.threshold
        var startY = item.height / 2
        var endX = item.width
        var endY = startY
        mousePress(item, startX, startY)
        mouseMoveSlowly(item,
                        startX, startY,
                        endX - startX, endY - startY,
                        10, 100)
        mouseRelease(item, endX, endY)
        mouseClick(item, startX, startY)
    }
}
