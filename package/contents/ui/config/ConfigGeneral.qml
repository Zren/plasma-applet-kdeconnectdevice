import QtQuick 2.0
import QtQuick.Controls 2.0 as QQC2
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

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
	PlasmaComponents3.RadioButton {
		id: radioButtonSizer
		visible: false
	}
	AppletConfig { id: appletConfig }
	SystemPalette { id: syspal }

	ConfigGroupBox {
		title: i18n("Select Device")
		DeviceSelector {
			id: deviceSelector
			anchors.fill: parent
			textColor: syspal.text
			iconBackgroundColor: theme.backgroundColor
		}
	}


	ConfigGroupBox {
		RowLayout {
			Rectangle {
				Layout.preferredWidth: radioButtonSizer.width
				Layout.preferredHeight: radioButtonSizer.width
				color: theme.backgroundColor
				radius: 4 * units.devicePixelRatio

				PlasmaCore.IconItem {
					id: icon
					anchors.fill: parent
					source: "smartphone"
				}

				IconCounterOverlay {
					anchors.fill: parent
					text: lowBatteryPercent.value
					heightRatio: 0.5
					backgroundColor: appletConfig.lowBatteryBackgroundColor
					textColor: appletConfig.lowBatteryTextColor
				}
			}

			ConfigSpinBox {
				id: lowBatteryPercent
				configKey: "lowBatteryPercent"
				before: i18n("Low Battery:")
				suffix: "%"
			}
		}
	}

	ConfigGroupBox {
		title: i18n("Icon")

		ConfigIcon {
			configKey: 'userDeviceIcon'
			previewIconSize: units.iconSizes.large
			placeholderValue: plasmoid.configuration.deviceIcon || "kdeconnect"
		}
	}
}
