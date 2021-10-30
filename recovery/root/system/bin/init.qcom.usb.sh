#!/system/bin/sh

# check configfs is mounted or not
if [ -d /config/usb_gadget ]; then
	# Chip-serial is used for unique MSM identification in Product string
	msm_serial=`cat /sys/devices/soc0/serial_number`;
	msm_serial_hex=`printf %08X $msm_serial`
	machine_type=`cat /sys/devices/soc0/machine`
	product_string="$machine_type-$soc_hwplatform _SN:$msm_serial_hex"
	echo "$(getprop ro.product.model)" > /config/usb_gadget/g1/strings/0x409/product

	# ADB requires valid iSerialNumber; if ro.serialno is missing, use dummy
	serialnumber=`cat /config/usb_gadget/g1/strings/0x409/serialnumber 2> /dev/null`
	if [ "$serialnumber" == "" ]; then
		serialno=1234567
		echo $serialno > /config/usb_gadget/g1/strings/0x409/serialnumber
	fi
fi
