import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras


FocusScope {
	id: fullRepresentation
	Layout.minimumWidth: units.gridUnit * 10
	Layout.minimumHeight: units.gridUnit * 10
	Layout.preferredWidth: units.gridUnit * 20

	property bool isDesktopContainment: false

	Loader {
		anchors.fill: parent
		source: plasmoid.configuration.deviceId ? "DeviceView.qml" : "DeviceSelector.qml"
	}

}
