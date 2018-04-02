import QtQuick 2.0
import "kdeconnect"

Item {
	id: currentDevice
	property string deviceId: plasmoid.configuration.deviceId
	property string deviceName: plasmoid.configuration.deviceName
	property string icon: plasmoid.configuration.userDeviceIcon || plasmoid.configuration.deviceIcon

	property var device: null

	Component {
		id: deviceComponent

		Item {
			property var battery: Battery {
				device: currentDevice.device
			}
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



	function share(url) {
		console.log('share', url)
		if (deviceId && url) {
			var cmd = "kdeconnect-cli -d " + executable.wrap(deviceId) + " --share " + executable.wrap(url)
			console.log('exec', cmd)
			executable.exec(cmd, function(cmd, exitCode, exitStatus, stdout, stderr) {
				console.log('execCallback', cmd)
				console.log('\t', exitCode)
				console.log('\t', exitStatus)
				console.log('\t', stdout)
				console.log('\t', stderr)

				if (exitCode == 0) {
					// sucess
				} else {
					// TODO: error
				}
			})
		} else {
			// TODO: error
		}
	}
}
