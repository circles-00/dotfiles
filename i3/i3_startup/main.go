package main

import (
	"fmt"
	"os/exec"
	"strconv"
	"strings"
	"time"
)

type Monitors struct {
	monitor1         string
	monitor2         string
	numberOfMonitors int
}

func reverseString(input string) string {
	runes := []rune(input)

	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}

	return string(runes)
}

func setupMonitors() Monitors {
	monitorsCmd := exec.Command("xrandr", "--listmonitors")

	rawMonitors, err := monitorsCmd.Output()
	monitors := string(rawMonitors)

	if err != nil {
		panic("MONITORS CANNOT BE SET")
	}

	outputLines := strings.Split(monitors, "\n")

	numberOfMonitorsLine := outputLines[0]
	rawNumberOfMonitors := strings.TrimSpace(strings.Split(numberOfMonitorsLine, ":")[1])

	numberOfMonitors, err := strconv.Atoi(rawNumberOfMonitors)
	if err != nil {
		panic("NUMBER OF MONITORS CANNOT BE READ")
	}

	// Note: reversing strings because there are a lot of spaces in the output of xrandr cmd, this is more reliable
	firstMonitor := reverseString(strings.Split(reverseString(outputLines[1]), " ")[0])

	if numberOfMonitors < 2 {
		return Monitors{
			monitor1:         firstMonitor,
			monitor2:         "",
			numberOfMonitors: numberOfMonitors,
		}
	}

	secondMonitor := reverseString(strings.Split(reverseString(outputLines[2]), " ")[0])
	print(firstMonitor, secondMonitor)

	// Below is written with 1 L fellas, 1, not 2, silly me
	xrandrCmd := exec.Command("xrandr", "--output", firstMonitor, "--auto", "--below", secondMonitor, "--auto")

	xRandrErr := xrandrCmd.Run()

	if xRandrErr != nil {
		panic("XRANDR CANNOT SET MONITORS")
	}

	return Monitors{
		monitor1:         firstMonitor,
		monitor2:         secondMonitor,
		numberOfMonitors: numberOfMonitors,
	}
}

func setupMTU() {
	mtuCmd := exec.Command("sudo", "ip", "link", "set", "dev", "wlp0s20f3", "mtu", "1350")

	mtuErr := mtuCmd.Run()

	if mtuErr != nil {
		panic("MTU CANNOT BE SET")
	}
}

func main() {
	monitors := setupMonitors()
	setupMTU()

	cmds := [][]string{
		{"i3-msg", "workspace 1; exec brave;"},
		{"i3-msg", "workspace 2; exec ghostty;"},
		{"i3-msg", "workspace 3; exec spotify;"},
		{"i3-msg", "workspace 4; exec /var/lib/flatpak/exports/bin/com.discordapp.Discord;"},
		{"i3-msg", "workspace 4; exec cliq;"},
	}

	for _, cmd := range cmds {
		i3WorkspacesCmd := exec.Command(cmd[0], cmd[1])

		_, err := i3WorkspacesCmd.Output()
		if err != nil {
			panic("ERROR SETTING I3 WORKSPACES")
		}

		if strings.Contains(cmd[1], "discord") || strings.Contains(cmd[1], "brave") {
			time.Sleep(3 * time.Second)
			continue
		}

		time.Sleep(1 * time.Second)
	}

	if monitors.numberOfMonitors < 2 {
		return
	}

	time.Sleep(3 * time.Second)
	i3ReassignWorkspacesDownCmd := exec.Command("i3-msg", fmt.Sprintf("workspace 3, move workspace to output %s; workspace 4, move workspace to output %s;", monitors.monitor2, monitors.monitor2))
	i3ReassignWorkspacesUpCmd := exec.Command("i3-msg", fmt.Sprintf("workspace 1, move workspace to output %s; workspace 2, move workspace to output %s;", monitors.monitor2, monitors.monitor2))

	i3ReassignWorkspacesUpCmd.Run()
	i3ReassignWorkspacesDownCmd.Run()

	reloadI3ConfigCmd := exec.Command("i3-msg", "restart")

	reloadI3ConfigCmd.Run()
}
