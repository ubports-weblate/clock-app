/*
 * Copyright (C) 2014-2015 Canonical Ltd
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

import QtQuick 2.4
import Ubuntu.Components 1.2
import "../components"

ListItem {
    id: userWorldCityDelegate

    function getTimeDiff(time) {
        var hours, minutes;
        time = Math.floor(time / 60)
        minutes = time % 60
        hours = Math.floor(time / 60)
        return [hours, minutes]
    }

    height: units.gu(9)
    divider.visible: false

    Item {
        id: delegate

        anchors {
            fill: parent
            margins: units.gu(2)
        }

        Column {
            id: cityColumn

            anchors {
                left: parent.left
                right: localTimeVisual.left
                rightMargin: units.gu(1)
                verticalCenter: parent.verticalCenter
            }

            Label {
                text: model.cityName
                objectName: "userCityNameText"
                width: parent.width
                elide: Text.ElideRight
                color: UbuntuColors.midAubergine
            }

            Label {
                text: model.countryName
                objectName: "userCountryNameText"
                fontSize: "xx-small"
                width: parent.width
                elide: Text.ElideRight
            }
        }

        Clock {
            id: localTimeVisual
            objectName: "localTimeVisual" + index

            /*
                 This function would not be required once the upstream QT bug at
                 https://bugreports.qt-project.org/browse/QTBUG-40275 is fixed.
                 Due to this bug we are returning a time string instead of a
                 time object which forces us to parse the string and convert it
                 into a time object here.
                */
            function getTime(timeString) {
                var properTime = new Date()
                properTime.setHours(timeString.split(":")[0])
                properTime.setMinutes(timeString.split(":")[1])
                properTime.setSeconds(0)
                return properTime
            }

            fontSize: units.dp(14)
            periodFontSize: units.dp(7)
            innerCircleWidth: units.gu(5)
            width: units.gu(7)

            analogTime: getTime(model.localTime)

            anchors.centerIn: parent

            Connections {
                target: clock
                onTriggerFlip: {
                    localTimeVisual.flipClock()
                }
            }

            Component.onCompleted: {
                isDigital = clockModeDocument.contents.digitalMode ? true : false
                if (clockModeDocument.contents.digitalMode) {
                    digitalModeLoader.setSource
                            ("../components/DigitalMode.qml",
                             {
                                 "width": innerCircleWidth,
                                 "timeFontSize": fontSize,
                                 "timePeriodFontSize": periodFontSize
                             })
                }
                else {
                    analogModeLoader.setSource(
                                "../components/AnalogMode.qml",
                                {
                                    "width": innerCircleWidth,
                                    "showSeconds": isMainClock
                                })
                }
            }
        }

        Label {
            id: relativeTimeLabel
            objectName: "relativeTimeLabel" + index

            anchors.left: localTimeVisual.right
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            fontSize: "xx-small"
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignRight
            text: {
                var day;

                // TRANSLATORS: this indicates if the time in a world clock
                // is behind or ahead of the time at the current location
                var isBehind = model.timeTo > 0 ? i18n.tr("behind")
                                                : i18n.tr("ahead")

                var timediff = getTimeDiff(Math.abs(model.timeTo))
                var minute = timediff[1]
                var hour = timediff[0]

                if(hour > 0 &&  minute > 0) {
                    // TRANSLATORS: the first argument is hour, followed by
                    // minute, and the translation for either 'behind' or
                    // 'ahead'
                    return (i18n.tr("%1h %2m %3"))
                    .arg(hour)
                    .arg(minute)
                    .arg(isBehind)
                }

                else if(hour > 0 && minute === 0) {
                    // TRANSLATORS: the first argument is hour, followed by the
                    // translation for either 'behind' or 'ahead'
                    return (i18n.tr("%1h %2"))
                    .arg(hour)
                    .arg(isBehind)
                }

                else if(hour === 0 && minute > 0) {
                    // TRANSLATORS: the first argument is minute, followed by the
                    // translation for either 'behind' or 'ahead'
                    return (i18n.tr("%1m %2"))
                    .arg(minute)
                    .arg(isBehind)
                }

                else {
                    return i18n.tr("Same time")
                }
            }
        }
    }
}
