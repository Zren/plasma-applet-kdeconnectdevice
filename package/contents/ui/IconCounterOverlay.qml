/* This file is a slightly modified version of TaskBadgeOverlay from org.kde.plasma.taskmanager */
/* See: https://github.com/KDE/plasma-desktop/blob/233ef875440e45fd7cf5715b0df372f4c22951dd/applets/taskmanager/package/contents/ui/TaskBadgeOverlay.qml */

/***************************************************************************
 *   Copyright (C) 2016 Kai Uwe Broulik <kde@privat.broulik.de>            *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
 ***************************************************************************/

import QtQuick 2.4

import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
	id: overlay
	property var iconItem
	readonly property int iconWidthDelta: (iconItem.width - iconItem.paintedWidth) / 2
	readonly property int iconHeightDelta: (iconItem.height - iconItem.paintedHeight) / 2
	property alias text: badgeLabel.text
	property color backgroundColor: theme.highlightColor
	property color textColor: theme.backgroundColor
	property real heightRatio: 0.4
	property real radius: 3 * units.devicePixelRatio
	readonly property int minSize: Math.min(width, height)
	property int minMaskSize: 28 * units.devicePixelRatio
	property bool useMask: minSize >= minMaskSize

	Item {
		id: badgeMask
		anchors.fill: parent
		visible: overlay.useMask

		Rectangle {
			readonly property int offset: Math.round(Math.max(units.smallSpacing / 2, badgeMask.width / 32))
			x: parent.width - width + offset
			y: parent.height - height + offset
			width: badgeRect.width + offset * 2
			height: badgeRect.height + offset * 2
			radius: overlay.radius

			// Badge changes width based on number.
			onWidthChanged: shaderEffect.mask.scheduleUpdate()
		}
	}

	ShaderEffect {
		id: shaderEffect
		anchors.fill: parent
		visible: overlay.useMask

		property var source: ShaderEffectSource {
			sourceItem: iconItem
			hideSource: overlay.visible && overlay.useMask
		}
		property var mask: ShaderEffectSource {
			sourceItem: badgeMask
			hideSource: true
			live: false
		}

		onWidthChanged: mask.scheduleUpdate()
		onHeightChanged: mask.scheduleUpdate()

		supportsAtlasTextures: true

		fragmentShader: "
			varying highp vec2 qt_TexCoord0;
			uniform highp float qt_Opacity;
			uniform lowp sampler2D source;
			uniform lowp sampler2D mask;
			void main() {
				gl_FragColor = texture2D(source, qt_TexCoord0.st) * (1.0 - (texture2D(mask, qt_TexCoord0.st).a)) * qt_Opacity;
			}
		"
	}

	Rectangle {
		id: badgeRect
		x: parent.width - width
		y: parent.height - height
		width: badgeLabel.width + overlay.radius
		height: badgeLabel.font.pixelSize + overlay.radius
		color: overlay.useMask ? overlay.backgroundColor : "transparent"
		radius: overlay.radius

		PlasmaComponents.Label {
			id: badgeLabel
			anchors.centerIn: parent
			width: paintedWidth
			height: Math.round(parent.height)
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
			// fontSizeMode: Text.Fit
			font.pointSize: -1
			font.pixelSize: Math.round(10 * units.devicePixelRatio)
			minimumPixelSize: 5
			color: overlay.useMask ? overlay.textColor : overlay.backgroundColor
			style: overlay.useMask ? Text.Normal : Text.Outline
			styleColor: overlay.textColor
			font.weight: Font.Black
			// font.bold: true
			// font.family: "Noto Mono"
		}
	}
}
