# IoT_Controller

First version of a flutter app that works with Arduino via Bluetooth communication

## IMPORTANT

It's vital to configure the proper Android permissions to use Bluetooth communication tools and protocols.
The AndroidManifest.xml in the Android folder of this repository should have everything correctly, but if an exception occurs
with flutter_bluetooth_serial, a possible solution is to add the namespace configuration manually to the package.
First locate the bluetooth serial package in your storage, then follow => flutter_bluetooth_serial-0.4.0\android\build.gradle
Then find the android {...} and add " namespace 'flutter.bluetooth.serial' " at the beginning without changing anything else
In the same package, go to => android\src\main\AndroidManifest.xml
Look for the <manifest..> tag, and if you see a line " package="io.github.edufolly.flutterbluetoothserial" ", delete it and don't change anything else.

Everything should be just fine now




