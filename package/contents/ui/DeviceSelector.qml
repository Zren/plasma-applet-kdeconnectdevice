import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import "./Utils.js" as Utils

ListView {
	implicitHeight: contentHeight

	property color textColor: theme.textColor
	property color iconBackgroundColor: "transparent"

	PlasmaComponents.RadioButton {
		id: radioButtonSizer
		visible: false
	}
	ExclusiveGroup { id: pairedDeviceGroup }

	model: pairedDevicesModel
	delegate: RadioButton {
		id: deviceSelectorDelegate

		anchors.left: parent.left
		anchors.right: parent.right

		checked: model.deviceId == plasmoid.configuration.deviceId
		exclusiveGroup: pairedDeviceGroup

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
			
			PlasmaComponents.Label {
				text: model.display
				color: textColor
			}
			PlasmaComponents.Label {
				text: model.deviceId
				opacity: 0.6
				color: textColor
			}
			Item { Layout.fillWidth: true }
		}

		onClicked: {
			console.log('clicked', model.display)

			plasmoid.configuration.deviceId = model.deviceId
			plasmoid.configuration.deviceName = model.display
			plasmoid.configuration.deviceIcon = deviceSelectorDelegate.deviceIconName
		}
	}
}