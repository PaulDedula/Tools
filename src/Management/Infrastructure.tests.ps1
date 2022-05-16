<#
.SYNOPSIS
    A quick way to run a bunch of one-off infrastructure tests
.DESCRIPTION
    Useful during cutovers to to new public ip addresses and hostnames. This is provides a simple
    interface for running tests with immediate results without waiting for/updating NMS systems.
    The portability of Pester tests makes this an easy way to perform multiple perspective testing.

.EXAMPLE
    Many NMS systems have the capability to run tests from multiple sources and confirm that a known
    path/thing is working. Setting up that capability can be combersome in some cases, or you may not
    want to clutter the NMS with ephemeral test data.

.EXAMPLE
    As an administrator testing a new VPN connection policy, you can run/rerun this series of tests
    before and after changing the policy. That would be much faster and more reliable than manual tests.

.EXAMPLE
    While performing a public IP address space cutover, a test subject could be populated with the new dns
    names that you're expecting. Repeatedly running the test would let you keep a close eye on DNS convergence.

.EXAMPLE
    Drop this in to SCCM/CWA/other RMM to provide a quick verification of service tool.
    Script can be triggered by service desk personel if an employee is reporting a service is
    offline.
#>

$config = Get-Content $PSScriptRoot\Infrastructure.tests.yaml | 
ConvertFrom-Yaml |
Select-Object -ExpandProperty config


Describe "[<testsubject.FriendlyName>] Infrastructure State Tests" -ForEach $config {
    $subject = $_.TestSubject

    Context "Name resolution" {
        # Foreach name record  -> it "should resolve"
        It "<name>'s <type> should be <value>" -TestCases $subject.nameRecords {
            $result = Resolve-DnsName -Name $name -Type $type 
            $result.IPAddress | Should -BeExactly $value
        }
    }
    Context "ICMP" {
        # Foreach IP Address -> it "should echo reply"
        It "Should echo reply from <ipaddress>" -TestCases $subject.Network {
            Test-Connection -Ping -IPv4 $IPAddress -Count 1 -TimeoutSeconds 1 -Quiet | Should -BeTrue
        }
        It "Should echo reply from <name>" -TestCases $subject.nameRecords {
            Test-Connection -Ping -IPv4 $name -Count 1 -TimeoutSeconds 1 -Quiet | Should -BeTrue
        }
    }
    Context "Layer 4" {
        # Foreach Config Port -> it "should TCP ack/synack/ack"
        It "Should setup TCP Connection with <IPAddress>:<Port>" -TestCases $subject.Network {
            if (-not $port) {Set-ItResult -Skipped -Because "Port not specified"}
            Test-Connection -IPv4 $IPAddress -TcpPort $port | Should -BeTrue
        }
    }
    Context "Content" {
        # Foreach Config Path -> it "should return data"
        It "Should connect to path <usinghostname><path>" -TestCases $subject.content {
            switch ($type) {
                'FileSystem' {
                    Test-Path -Path $Path | Should -BeTrue
                }
                'SMB' {
                    $fullpath = "\\" + $usingHostname + $path
                    Test-Path -Path $fullpath | Should -BeTrue
                }
                'HTTP' {
                    $fullpath = "HTTP://" + $usingHostname + $path
                    (Invoke-WebRequest -Uri $fullpath).statusCode | Should -Be 200
                } default {
                    Set-ItResult -Inconclusive -Because "Type of '$type' is not supported"
                }
            }
        }
    }
}