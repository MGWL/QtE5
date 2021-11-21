<u>update for Qt 5.12.7</u> See build/QtE5Widgets/ReadMe.txt and source/qte5.d

# QtE56 is Qt-based library, provides easy access to Qt-5 from D and C++.

![logo](https://github.com/MGWL/QtE5/blob/master/ICONS/qte5.png)

It uses dynamic Qt5 loading and a predefined set of slots, allows you not to use the metacompiler. To compile and execute an application, it is enough to have only QtE5 and some DLL/SO from Qt. There is no need to install Qt.

## Usage
```
domnload demo_Qt6 - This for Win64+Qt6_dll* and compile, execute demo ...

Make app for D:
    dmd app.d qte5.d
    
Make app for C++:
    dmc:  dmc app.cpp qte5.cpp
    g++:  g++ app.cpp qte5.cpp -ldl
```
![QtE5 Architecture](https://github.com/MGWL/QtE5/blob/master/arx.PNG)

**Short video about qte5 and ide5 in Linux [https://www.youtube.com/watch?v=RBan5Dwt_JM](https://www.youtube.com/watch?v=RBan5Dwt_JM)**
<br>
**QtE5 in Mac OSX 10.10.5 https://www.youtube.com/watch?v=JbvUJwShN_c**
<br>
**Slots and signals in QtE5 http://lhs-blog.info/programming/dlang/slotyi-i-signalyi-v-qte5/**
<br>
<br>
QtE5 - uses the following libraries depending from OS<br>
    QtE5Widgets32.dll     --->  Windows 32<br>
    QtE5Widgets64.dll     --->  Windows 64<br>
    libQtE5Widgets32.so   --->  Linux   32<br>
    libQtE5Widgets64.so   --->  Linux   64<br>
    libQtE5Widgets64.dylib ---> OSX 10.5 64<br>
    
<p>The most actual version for Windows 32 (QtE5Widgets32.dll) as on it the basic working out and testing is conducted.</p>   
<br>

##Screenshot    
![screen](https://pp.userapi.com/c638923/v638923410/5e562/5VCDQWdgr_M.jpg)
Windows 32. Hello World.
![screen](https://pp.userapi.com/c840122/v840122383/70ffe/OIi51ZRtG3c.jpg)
OS X Yosemite 64. Mini browser witch QWebEngineView.
<hr>
The program is distributed under the MIT license


The MIT License (MIT)

Copyright © «year» «copyright holders»

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
