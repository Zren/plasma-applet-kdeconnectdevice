import QtQuick 2.0

QtObject {
	id: device
	property string deviceId: plasmoid.configuration.deviceId // "77e3a0dac0e49055"
	property string deviceName: plasmoid.configuration.deviceName  // "Asus Nexus 7"
	property string icon: plasmoid.configuration.deviceIcon // "tablet"



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

	property var connections: Connections {
		target: plasmoid.configuration
		// onDeviceIdChanged: {

		// }
	}
}
