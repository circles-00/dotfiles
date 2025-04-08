package main

import (
	"bytes"
	"fmt"
	"os/exec"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"
)

type Monitors struct {
	monitor1         string
	monitor2         string
	numberOfMonitors int
}

func setMaxRefreshRateFor(output string) error {
	if !isOutputConnected(output) {
		return fmt.Errorf("output %s is not connected", output)
	}

	currentRes := getCurrentResolution(output)
	if currentRes == "" {
		return fmt.Errorf("could not determine current resolution for %s", output)
	}

	bestRate := getHighestRefreshRate(output, currentRes)
	if bestRate <= 0 {
		return fmt.Errorf("could not find refresh rates for %s at resolution %s", output, currentRes)
	}

	fmt.Printf("Setting %s to %s @ %.2fHz\n", output, currentRes, bestRate)
	return setResolution(output, currentRes, bestRate)
}

func isOutputConnected(output string) bool {
	cmd := exec.Command("xrandr", "--query")
	out, _ := cmd.Output()
	lines := strings.Split(string(out), "\n")
	for _, line := range lines {
		if strings.HasPrefix(line, output+" connected") {
			return true
		}
	}
	return false
}

func getCurrentResolution(output string) string {
	cmd := exec.Command("xrandr", "--query")
	out, _ := cmd.Output()
	lines := strings.Split(string(out), "\n")

	sectionStarted := false
	for _, line := range lines {
		if strings.HasPrefix(line, output+" connected") {
			sectionStarted = true
			continue
		}
		if sectionStarted {
			if strings.Contains(line, "*") {
				fields := strings.Fields(line)
				return fields[0]
			} else if strings.TrimSpace(line) == "" {
				break
			}
		}
	}
	return ""
}

func getHighestRefreshRate(output, resolution string) float64 {
	cmd := exec.Command("xrandr", "--query")
	out, _ := cmd.Output()
	lines := strings.Split(string(out), "\n")

	sectionStarted := false
	var rates []float64
	modeLine := regexp.MustCompile(`^\s*` + regexp.QuoteMeta(resolution) + `\s+`)

	for _, line := range lines {
		if strings.HasPrefix(line, output+" connected") {
			sectionStarted = true
			continue
		}
		if sectionStarted {
			if strings.TrimSpace(line) == "" || !strings.HasPrefix(line, " ") {
				break
			}
			if modeLine.MatchString(line) {
				fields := strings.Fields(line)
				for _, field := range fields[1:] {
					// Remove trailing + or *
					clean := strings.TrimRight(field, "+*")
					if hz, err := strconv.ParseFloat(clean, 64); err == nil {
						rates = append(rates, hz)
					}
				}
			}
		}
	}
	sort.Sort(sort.Reverse(sort.Float64Slice(rates)))
	if len(rates) > 0 {
		return rates[0]
	}
	return 0
}

func setResolution(output, resolution string, rate float64) error {
	cmd := exec.Command("xrandr", "--output", output, "--mode", resolution, "--rate", fmt.Sprintf("%.2f", rate))
	var stderr bytes.Buffer
	cmd.Stderr = &stderr
	err := cmd.Run()
	if err != nil {
		return fmt.Errorf(stderr.String())
	}
	return nil
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
	setMaxRefreshRateFor(monitors.monitor2)

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
