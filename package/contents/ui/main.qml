import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.kdeconnect 1.0 as KDEConnect
import "./lib"

Item {
	id: main

	AppletConfig { id: appletConfig }
	ExecUtil { id: executable }

	KDEConnect.DevicesModel {
		id: pairedDevicesModel
		displayFilter: KDEConnect.DevicesModel.Paired
	}

	Device {
		id: currentDevice
	}

	Plasmoid.icon: currentDevice.icon || "kdeconnect"
	Plasmoid.toolTipMainText: currentDevice.deviceName || i18n("KDE Connect Device")
	Plasmoid.toolTipSubText: currentDevice.deviceId ? i18n("Drag and drop to send a link to device") : i18n("Please select device")

	Plasmoid.compactRepresentation: CompactRepresentation {}

	Plasmoid.fullRepresentation: FullRepresentation {
		Plasmoid.backgroundHints: isDesktopContainment ? PlasmaCore.Types.NoBackground : PlasmaCore.Types.DefaultBackground
		isDesktopContainment: plasmoid.location == PlasmaCore.Types.Floating
	}

	Component.onCompleted: {

	}
}
