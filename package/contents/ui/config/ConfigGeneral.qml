import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import org.kde.kdeconnect 1.0 as KDEConnect
import ".."
import "../lib"

ConfigPage {
	id: page
	showAppletVersion: true

	KDEConnect.DevicesModel {
		id: pairedDevicesModel
		displayFilter: KDEConnect.DevicesModel.Paired
	}

	ConfigSection {
		DeviceSelector {
			id: deviceSelector
			anchors.fill: parent
		}
	}
}
