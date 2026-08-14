# Middle Earth Kuberntes Home Lab

This repo contains a playground where notes, scripts and other code snipptes used during the build of a kubernetes cluster from scratch and exploration of kubernetes core concepts are kept.

In my current role as a developer of automation solutions based on VMware Aria Automation I'm preparing myself for the switch to the successor VMware Cloud Foundation (VCF). VCF is a major overhaul of the on-prem cloud stack offering from VMware/Broadcom where vSphere Kubernetes Service (VKS) is a core component. Given the increasingly important role kubernetes have in the automation layer, VCF Automation, basic knowledge about kubernetes core concepts is good to have.

## Hardware bill of materials

* 4 Raspberry Pi 5, 4 GB
* 4 SD cards for storage, 64 GB 
* 4 Waveshare PoE hats
* Ubiquiti UniFi NAS2
    * Simple and affordable storage with support for NFS
    * 2 HDD drives, 3TB
* Ubiquiti UniFi Switch Lite 16 PoE
    * or any other PoE switch with at least 20 watt power budget
* DeskPi RackMate T0 4U 10 inch rack
    * Not really needed, but it makes the lab environment free from cable clutter

## Operating system

* Raspberry Pi OS Lite

### OS image customizatios

* City 'Stockholm'
* Time zone 'Europe/Stockholm'
* Keyboard layout 'se'
* Wireless networking disabled
* Local user 'pi'
* SSH service with password authentication
* Raspberry Pi Connect disabled

## Main software components

* Container runtime (CRI)
  * containerd
  * runc
  * CNI plugins
* Kubernetes
  * kubeadm
  * kubelet
  * kubectl
* Storage and networking
  * NFS Subdir External Provisioner
  * Calico
  * (OpenEBS)

## Inspiration and product documentationn

* [piyushsachdeva/CKA-2024](https://github.com/piyushsachdeva/CKA-2024)
* [Kuberbetes Documentation](https://kubernetes.io/docs/home)
* [NFS Subdir External Provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)
* [Calico Documentation](https://docs.tigera.io/calico/latest/about)
* [OpenEBS Documentation](https://openebs.io/docs/)
