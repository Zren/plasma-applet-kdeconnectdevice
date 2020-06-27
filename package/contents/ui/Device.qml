import QtQuick 2.0
import "./kdeconnect"

Item {
	id: currentDevice
	property string deviceId: plasmoid.configuration.deviceId
	property string deviceName: plasmoid.configuration.deviceName
	property string icon: plasmoid.configuration.userDeviceIcon || plasmoid.configuration.deviceIcon

	property var device: null

	Component {
		id: deviceComponent

		Item {
			property var battery: Battery { device: currentDevice.device }
			property var share: Share { device: currentDevice.device }
			property var sms: SMS { device: currentDevice.device }
		}
	}
	Loader {
		id: deviceLoader
		active: currentDevice.device
		sourceComponent: deviceComponent
	}

	function updateDevice() {
		for (var i = 0; i < pairedDevicesModel.count; i++) {
			var device = pairedDevicesModel.getDevice(i)
			// console.log(i, device, device.id(), device.type, device.name)
			if (device.id() == currentDevice.deviceId) {
				currentDevice.device = null // Trigger deviceLoader.active = false
				currentDevice.device = device
				return
			}
		}
		currentDevice.device = null
	}
	Connections {
		target: currentDevice
		onDeviceIdChanged: currentDevice.updateDevice()
	}
	Connections {
		target: pairedDevicesModel
		onRowsChanged: currentDevice.updateDevice()
	}
	Component.onCompleted: currentDevice.updateDevice()

	//---
	property var battery: deviceLoader.item ? deviceLoader.item.battery : null
	property bool batteryAvailable: battery && battery.charge >= 0 ? battery.available : false
	property bool batteryCharging: battery ? battery.charging : false
	property int batteryCharge: battery ? battery.charge : 0
	property string batteryDisplayString: battery ? battery.displayString : i18n("No info")
	property bool isLowBattery: battery && batteryCharge <= plasmoid.configuration.lowBatteryPercent

	// onDeviceChanged: console.log('Device.device', device)
	// onDeviceIdChanged: console.log('Device.deviceId', deviceId)
	// onDeviceNameChanged: console.log('deviceName', deviceName)
	// onBatteryChanged: console.log('battery', battery)
	// onBatteryAvailableChanged: console.log('batteryAvailable', batteryAvailable)
	// onBatteryChargingChanged: console.log('batteryCharging', batteryCharging)
	// onBatteryChargeChanged: console.log('batteryCharge', batteryCharge)
	// onBatteryDisplayStringChanged: console.log('batteryDisplayString', batteryDisplayString)

	//---
	property var share: deviceLoader.item ? deviceLoader.item.share : null
	function shareUrl(url) {
		if (!share) {
			return
		}
		share.plugin.shareUrl(url)
	}
	function shareUrlList(urls) {
		if (!share) {
			return
		}
		// share.plugin.shareUrls(urls) // Doesn't work.

		for (var i = 0; i < urls.length; i++) {
			shareUrl(urls[i])
		}
	}

	//---
	property var sms: deviceLoader.item ? deviceLoader.item.sms : null

	function openSms() {
		if (!sms) {
			return
		}
		sms.plugin.launchApp()
	}
}
