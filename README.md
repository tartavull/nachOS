# nachOS
Bare-metal programming for Raspberry Pi zero W.

### Step 1: Format your SD Card
Create a single fat32 partition, label it "boot" and flag it as "lba".

### Step 2: Copy Bootloader
Copy sdcard/bootcode.bin and start.elf to the root of your recently formatted  SD Card.

### Step 3: Copy Kernel
Change directory to one of the many available kernels, compile it, and move it to the SD Card.
```bash
cd kernels/0_turn_on_led
make
cp kernel.img /mnt/sdcard/kernel.img
```
