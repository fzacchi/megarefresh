## Welcome to Zak's MegaRefresh Script



### What?

A set of scripts for RetroPie on the Raspberry Pi that enable dynamic, game-specific refresh rate switching on standard LCD monitors.



### Why?

We tend to think of LCD monitors without Freesync or G-Sync as being able to only run at their native ~60 Hz refresh rate, but in reality they can switch to other rates with the right invocations. So far it's been possible to use that feature in a retrogaming context only on MAME setups on PC. With MegaRefresh the Raspberry Pi can now do it as well, across all the RetroPie systems and emulators.

In practice this allows PAL home computer systems, PAL consoles and especially arcade ROMs to run against a monitor that's synced to the game's refresh rate instead of being fixed at 60 Hz, with a deviation of no more than 0.5 Hz in the worst case.  Arcade games span a refresh range of 50 to 63 Hz and most LCD monitors can cover that.

It's astonishing how running a game at the right refresh rate can result in such a drastic difference in perceived emulation quality all else being equal. The result is that every game runs at the proper speed, with the music at the right pitch, and more importantly scrolls smoothly.

One thing that both home computer and arcade games always have had is perfectly fluid scrolling, no matter how rudimentary the graphics were. That's lost on a fixed refresh setup, and it's back with MegaRefresh. Compare the spinning character carousel shown when inserting a coin in Mortal Kombat, the first level in Shadow of the Beast on the Amiga, any PAL C64 scroller or any Neo Geo game with and without it to see the difference. Transparency or shadow effects relying on fast flickering look as they're supposed to again.

Details like that have been bothering me since way back, wondering why all those early MAME games played on 85 Hz 800x600 VGA monitors just didn't feel like I remembered them at all. I knew that the blocky look was due to the lack of scanlines and other CRT artifacts, but had no solution for the choppy scrolling. What's indeed puzzling is how long we put up with fixed refresh instead of this.

Think of MegaRefresh as CRT SwitchRes-lite for everyone on an LCD monitor. It's not the perfect solution that modeline generation on CRT is, but it's way simpler and immensely more practical. Coupled with a good CRT shader it brings the feel of PAL systems and nonstandard refresh rate games from subjectively unbearable to close enough to be enjoyable, at least for my taste. Unlike a CRT rig it needs no calibration, no extra hardware, no configuration, no compromise settings between modes and no setup apart from the initial installation.  Speaking of which ...



### How?



#### Installation instructions

- Online - recommended

You'll need a working internet connection on RetroPie; get to the command prompt with PuTTY or by exiting EmulationStation with F4, and type or paste

`wget -O - https://raw.githubusercontent.com/fzacchi/megarefresh/master/install.sh | bash`



- Offline - if you really have to

You'll need access to the RetroPie SD card filesystem on a separate PC (using Linux, a Linux virtual machine, DiskGenius on Windows, Paragon extFS for Mac, or another solution).

Download https://raw.githubusercontent.com/fzacchi/megarefresh/master/install.sh to your PC

Download https://github.com/fzacchi/megarefresh/archive/master.zip to your PC, it will be saved as `megarefresh-master.zip`, rename it back to `master.zip`

Create a new directory on the SD card called `megarefresh` in `/opt/retropie/configs/all/`

Copy `install.sh` and `master.zip` to `/opt/retropie/configs/all/megarefresh/`

Put the SD card back in the Pi and boot RetroPie

Get to the command prompt by exiting EmulationStation with F4, and type

`cd /opt/retropie/configs/all/megarefresh/`

`cat install.sh | bash`



MegaRefresh assumes that there are no pre-existing `runcommand-onstart.sh` and `runcommand-onend.sh` files present in `/opt/retropie/configs/all`, which should be the case in a clean RetroPie installation. If for any reason they are there the MegaRefresh installer will not overwrite them and will keep its versions in its `/opt/retropie/configs/all/megarefresh/` directory. It will be then necessary to call `megarefresh-onstart.sh` and `megarefresh-onend.sh` from your own `runcommand-onstart.sh` and `runcommand-onend.sh`, which should prove simple - just a few lines to be copied and pasted at the right position. See the actual files for instructions.

Some pre-made images use runcommand-onstart and -onend to handle launch videos, and re-create them from scratch each time launch videos are toggled on or off in the options menu. In that case find your preferred setting then paste the MegaRefresh launch commands in the pre-existing runcommand files.



#### Usage

There is no configuration needed after installation, everything should be completely automatic. MegaRefresh will launch each game or system at the proper refresh and set the 60 Hz standard one upon exiting back into EmulationStation. It will auto-detect and maintain your monitor's native resolution and will display a short message before launching a game if it's switching the refresh rate to a custom setting. When an NTSC or 60 Hz ROM is launched there will be no notification.

There is still some scrolling micro-stuttering at times even when using MegaRefresh: setting Threaded Video to OFF in the RetroArch cores seems to help, if your Pi is powerful enough (3B+ is). To do it for every core set `video_threaded = "false"` in `/opt/retropie/configs/all/retroarch.cfg`

The experimental lr-mame2003-plus core currently doesn't work as expected with the standard settings, causing very choppy scrolling. The fix is setting "Bypass audio skew" as disabled in the core's quick menu/options section (last on the bottom). The option is present only in very recent builds of the core, since 1.7.6 onwards. Every other libretro arcade core works as it should.

The list of systems and arcade games ROMs affected by MegaRefresh is kept in two files, `/opt/retropie/configs/all/megarefresh/refreshlist.txt` and `systems.txt`. The format (`romname refresh` and `systemname refresh`) is self-explanatory. 

There is an additional `skip.txt` file in the same directory. MegaRefresh will be completely bypassed for any system, emulator or rom on that list. 

When adding systems or ROMs or changing included ones make sure to round the game or system refresh frequency to the nearest integer value.

For console systems with mixed romsets in the same directory (with both PAL and NTSC ROMs, or Europe and USA/Japan/World ROMs) MegaRefresh will attempt to determine the ROM's region and corresponding video mode by parsing the filename looking for tags like (PAL),  (Europe), etc.

If you get some kind of 'mode not supported' OSD message or RetroPie hangs on a black screen after the MegaRefresh launch notification your monitor isn't compatible, unfortunately. In that case reboot from the command line or power cycle, at the next boot RetroPie will start at the usual 60 Hz frequency and you can disable MegaRefresh with its toggle utility.



#### Configuration

After installation there will be a sub-menu called "Zak's MegaRefresh" in the main RetroPie options menu, containing six utilities:

- A toggle utility to enable and disable MegaRefresh if for some reason it's incompatible with your LCD monitor or for troubleshooting
- An update utility to reinstall or update MegaRefresh to the latest version (internet connection required)
- A shortcut to this file
- A shortcut to edit `systems.txt` to add or remove systems and tweak the existing ones (keyboard required)
- A shortcut to edit `refreshlist.txt`, to tweak the existing games and add newly supported games (keyboard required)
- A shortcut to edit `skip.txt` (keyboard required)



#### Hardware Compatibility

All testing and development have been done on a Raspberry Pi 3B+. If you're using older Pis make sure to update the firmware to the latest version.

MegaRefresh has been tested with the following monitors:

- Samsung S27C350H: Working
- LG M2062D: Working
- Asus VK266: Working
- Samsung T240HD: Doesn't work when using the HDMI input. A 3€ HDMI to DVI adapter on Amazon and using the DVI input on the monitor solves the problem.
- LG M1717TM: 4:3, DVI-only. Works perfectly with an HDMI to DVI adapter.

Please test it with every monitor and Pi version out there and let me know what works and what doesn't.



#### For RetroPie image creators

It would be amazing if MegaRefresh came standard on community-made RetroPie images, or even - a man can dream - the official one. If you're a custom RetroPie image creator you can pre-install MegaRefresh but leave it disabled for maximum safety (even though I haven't been able to find an incompatible monitor yet) by deleting the `megarefresh-enabled` file in `/opt/retropie/configs/all/megarefresh/`

Your image users will then use the toggle utility in the options menu to enable it should they so choose.



#### Donate

MegaRefresh is the result of a lot of trial and error, research and experimentation. In particular getting from a working proof of concept to its present release version has proven to require a substantial amount of work. I'm delighted to finally be able to contribute something back to the emulation community, but if you wish to show a token of appreciation and support further development please consider donating any amount of your choice at https://www.paypal.me/zacchi

Thanks :)



#### The Future

Now that smart refresh sync and CRT shaders are in the 'good enough' phase, the more urgent priorities on the Pi are audio latency and input lag. Beam raced vsync or the new Rivatuner scanline sync should help with input lag, but more importantly we need better audio drivers and a better audio pipeline to get below the ghastly ~60ms of latency we have now, ideally in the sub-10ms range. The PortAudio implementation in GroovyMAME that got latency in the 10ms range does wonders for responsiveness.



#### Contact

The project's official page is https://github.com/fzacchi/megarefresh

E-mail me for any inquiry at fzlists@gmail.com



#### Thanks to:

Calamity for GroovyMAME and the initial inspiration for VRR on LCDs

Big Blue Frontend for the Youtube tutorials

Chris 'Perifractic' Simpson

@Fran_Tron and the RGB-Pi project for the original arcade refresh list

Vincenzo for the JammaPI project and help

The Arcade Club: GB, TC & LL

The worldwide retrogaming, retrocomputing and emulation communities - you all rock

