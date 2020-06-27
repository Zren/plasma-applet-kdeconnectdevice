import QtQuick 2.0
import QtQuick.Controls 2.0 as QQC2
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

import "./Utils.js" as Utils

ListView {
	implicitHeight: contentHeight

	property color textColor: theme.textColor
	property color iconBackgroundColor: "transparent"

	PlasmaComponents3.RadioButton {
		id: radioButtonSizer
		visible: false
	}

	model: pairedDevicesModel

	QQC2.ButtonGroup { id: pairedDeviceGroup }

	delegate: PlasmaComponents3.RadioButton {
		id: deviceSelectorDelegate

		anchors.left: parent.left
		anchors.right: parent.right

		QQC2.ButtonGroup.group: pairedDeviceGroup

		checked: model.deviceId == plasmoid.configuration.deviceId

		property var deviceIconName: Utils.parseIconName(model.iconName)

		RowLayout {
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.leftMargin: radioButtonSizer.width

			Rectangle {
				Layout.preferredWidth: radioButtonSizer.width
				Layout.preferredHeight: radioButtonSizer.width
				color: iconBackgroundColor
				radius: 4 * units.devicePixelRatio

				PlasmaCore.IconItem {
					anchors.fill: parent
					source: deviceSelectorDelegate.deviceIconName
				}
			}
			
			PlasmaComponents3.Label {
				text: model.display
				color: textColor
			}
			PlasmaComponents3.Label {
				text: model.deviceId
				opacity: 0.6
				color: textColor
			}
			Item { Layout.fillWidth: true }
		}

		onClicked: {
			plasmoid.configuration.deviceId = model.deviceId
			plasmoid.configuration.deviceName = model.display
			plasmoid.configuration.deviceIcon = deviceSelectorDelegate.deviceIconName
		}
	}
}
