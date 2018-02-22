import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

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

	PlasmaCore.IconItem {
		id: icon
		anchors.fill: parent
		source: dropArea.containsDrag ? "emblem-shared-symbolic" : plasmoid.icon
	}

	// IconCounterOverlay {
	// 	anchors.fill: parent
	// 	text: noteItem.incompleteCount
	// 	visible: noteItem.incompleteCount > 0
	// 	heightRatio: 0.5
	// }

	onClicked: plasmoid.expanded = !plasmoid.expanded


	DropArea {
		id: dropArea
		anchors.fill: parent

		// org.kde.plasma.quickshare
		function objectToArray(object) {
			var array = [];
			for(var v in object) {
				// toString() here too because sometimes the contents are non-string (eg QUrl)
				array.push(object[v].toString());
			}
			return array;
		}

		onEntered: {
			if (drag.hasUrls) {
				var urls = objectToArray(drag.urls)
				drag.accepted = true
			}
		}

		onDropped: {
			if (drop.hasUrls) {
				var urls = objectToArray(drop.urls)
				for (var i = 0; i < urls.length; i++) {
					var url = urls[i]
					device.share(url)
				}
				drop.accepted = true
			}
		}
	}
}
