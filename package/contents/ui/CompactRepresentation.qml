import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

import "Utils.js" as Utils

MouseArea {
	readonly property bool inPanel: (plasmoid.location == PlasmaCore.Types.TopEdge
		|| plasmoid.location == PlasmaCore.Types.RightEdge
		|| plasmoid.location == PlasmaCore.Types.BottomEdge
		|| plasmoid.location == PlasmaCore.Types.LeftEdge)

	Layout.minimumWidth: {
		switch (plasmoid.formFactor) {
		case PlasmaCore.Types.Vertical:
			return 0;
		case PlasmaCore.Types.Horizontal:
			return height;
		default:
			return units.gridUnit * 3;
		}
	}

	Layout.minimumHeight: {
		switch (plasmoid.formFactor) {
		case PlasmaCore.Types.Vertical:
			return width;
		case PlasmaCore.Types.Horizontal:
			return 0;
		default:
			return units.gridUnit * 3;
		}
	}

	Layout.maximumWidth: inPanel ? units.iconSizeHints.panel : -1
	Layout.maximumHeight: inPanel ? units.iconSizeHints.panel : -1

	// property int testSize: 20
	// Layout.minimumWidth: testSize
	// Layout.minimumHeight: testSize
	// Layout.preferredWidth: Layout.minimumWidth
	// Layout.preferredHeight: Layout.minimumHeight
	// Layout.maximumWidth: Layout.minimumWidth
	// Layout.maximumHeight: Layout.minimumHeight

	// Timer {
	// 	repeat: true
	// 	running: true
	// 	interval: 2000
	// 	onTriggered: {
	// 		parent.testSize += 2
	// 		console.log('testSize: ' + parent.testSize + 'px')
	// 	}
	// }

	PlasmaCore.IconItem {
		id: icon
		anchors.fill: parent
		source: dropArea.containsDrag ? "emblem-shared-symbolic" : plasmoid.icon
	}

	IconCounterOverlay {
		anchors.fill: parent
		iconItem: icon
		text: currentDevice.batteryCharge
		visible: currentDevice.batteryAvailable && !dropArea.containsDrag
		heightRatio: 0.5
		backgroundColor: currentDevice.isLowBattery ? appletConfig.lowBatteryBackgroundColor : theme.highlightColor
		textColor: currentDevice.isLowBattery ? appletConfig.lowBatteryTextColor : theme.backgroundColor
	}

	onClicked: plasmoid.expanded = !plasmoid.expanded


	DropArea {
		id: dropArea
		anchors.fill: parent

		function parseUrls(object) {
			var array = []
			for(var v in object) {
				// toString() here too because sometimes the contents are non-string (eg QUrl)
				var url = object[v].toString()
				if (array.indexOf(url) === -1) {
					array.push(url)
				}
			}
			return array
		}

		onEntered: {
			if (drag.hasUrls) {
				var urls = parseUrls(drag.urls)
				drag.accepted = true
			}
		}

		onDropped: {
			if (drop.hasUrls) {
				var urls = parseUrls(drop.urls)
				currentDevice.shareUrlList(urls)
				drop.accepted = true
			}
		}

		PlasmaCore.ToolTipArea {
			id: dropAreaToolTip
			anchors.fill: parent
			location: plasmoid.location
			active: true
			mainText: i18nd("plasma_applet_org.kde.kdeconnect", "File Transfer")
			subText: i18nd("plasma_applet_org.kde.kdeconnect", "Drop a file to transfer it onto your phone.")
		}
	}
}
