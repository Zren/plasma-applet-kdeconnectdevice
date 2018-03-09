.pragma library

function endsWidth(a, b) {
	if (a.length >= b.length) {
		var c = a.substr(a.length - b.length)
		return c == b
	} else {
		return false
	}
}

function parseIconName(iconName) {
	// https://github.com/KDE/kdeconnect-kde/blob/956d515fe920a518fc6feae6472287fd6f6f21d5/core/device.cpp#L422
	// https://github.com/KDE/kdeconnect-kde/blob/956d515fe920a518fc6feae6472287fd6f6f21d5/core/device.cpp#L403
	var statusList = [
		'disconnected', // put before 'connected'
		'connected',
		'trusted',
	]
	for (var i = 0; i < statusList.length; i++) {
		var status = statusList[i]
		if (endsWidth(iconName, status)) {
			iconName = iconName.substr(0, iconName.length - status.length)
		}
	}
	if (iconName == "laptop") {
		iconName = "computer-laptop"
	}
	return iconName
}

function setAlpha(c, a) {
	return Qt.rgba(c.r, c.g, c.b, a)
}
