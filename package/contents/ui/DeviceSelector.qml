import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import "./Utils.js" as Utils

ListView {
	RadioButton {
		id: radioButtonSizer
		visible: false
	}
	ExclusiveGroup { id: pairedDeviceGroup }

	model: pairedDevicesModel
	delegate: RadioButton {
		id: deviceSelectorDelegate

		anchors.left: parent.left
		anchors.right: parent.right

		exclusiveGroup: pairedDeviceGroup

		property var deviceIconName: Utils.parseIconName(model.iconName)
		

		RowLayout {
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.leftMargin: radioButtonSizer.width

			PlasmaCore.IconItem {
				Layout.preferredWidth: radioButtonSizer.width
				Layout.preferredHeight: radioButtonSizer.width
				source: deviceSelectorDelegate.deviceIconName
			}
			
			PlasmaComponents.Label {
				text: model.display
			}
			PlasmaComponents.Label {
				text: model.deviceId
				opacity: 0.6
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