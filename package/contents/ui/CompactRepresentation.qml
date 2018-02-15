import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.draganddrop 2.0 as DragAndDrop

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


	DragAndDrop.DropArea {
		id: dropArea
		anchors.fill: parent

		preventStealing: true

		function parseUrl(event) {
			if (event && event.mimeData && event.mimeData.url) {
				return event.mimeData.url.toString()
			} else {
				return ""
			}
		}
		function dragTick(eventType, event) {
			console.log(eventType, event.x, event.y)
			var url = parseUrl(event)
			if (url) {
				console.log('\t' + url)
			}
		}
		onDragEnter: {
			dragTick('onDragEnter', event)
			console.log('\t', event.proposedAction, event.possibleActions)
			if (parseUrl(event) && event.proposedAction == Qt.CopyAction) {
				event.accept(event.proposedAction)
			} else {
				event.ignore()
			}
		}
		onDragMove: {
			dragTick('onDragMove', event)
			console.log('\t', event.proposedAction, event.possibleActions)
			if (parseUrl(event) && event.proposedAction == Qt.CopyAction) {
				event.accept(event.proposedAction)
			} else {
				event.ignore()
			}
		}
		onDragLeave: dragTick('onDragLeave', event)
		onDrop: {
			dragTick('onDrop', event)
			var url = parseUrl(event)
			if (url) {
				console.log('device', device)
				device.share(url)
			}

			// console.log('\t', JSON.stringify(event.mimeData, null, '\t'))
		}
	}
}
