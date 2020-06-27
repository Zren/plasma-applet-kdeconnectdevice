import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0

PlasmaComponents3.Page {
	id: deviceView

	header: PlasmaExtras.PlasmoidHeading {
		id: headerArea

		RowLayout {
			width: parent.width

			PlasmaExtras.Heading {
				Layout.fillWidth: true
				Layout.leftMargin: units.smallSpacing
				level: 1
				text: currentDevice.deviceName || i18n("KDE Connect Device")
			}

			PlasmaComponents3.ToolButton {
				icon.name: "window-pin"
				checkable: true
				checked: plasmoid.configuration.pin
				onToggled: plasmoid.configuration.pin = checked
				PlasmaComponents3.ToolTip {
					text: i18n("Keep Open")
				}
			}
		}

	}

	FocusScope {
		anchors.fill: parent
		anchors.topMargin: units.smallSpacing * 2

		focus: true

		Column {
			PlasmaComponents3.Button {
				visible: !!currentDevice.sms && currentDevice.sms.available
				text: i18nd("plasma_applet_org.kde.kdeconnect", "SMS Messages")
				icon.name: "message-new"
				onClicked: currentDevice.openSms()
			}
		}
	}
}
