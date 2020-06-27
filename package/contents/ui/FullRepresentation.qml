import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore

FocusScope {
	id: fullRepresentation
	Layout.minimumWidth: units.gridUnit * 10
	Layout.minimumHeight: units.gridUnit * 10
	Layout.preferredWidth: units.gridUnit * 20
	Layout.preferredHeight: units.gridUnit * 20

	property bool isDesktopContainment: false

	Loader {
		anchors.fill: parent
		source: plasmoid.configuration.deviceId ? "DeviceView.qml" : "DeviceSelector.qml"
	}
}
