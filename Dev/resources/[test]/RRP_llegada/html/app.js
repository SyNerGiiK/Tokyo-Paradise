let soundSend = false
window.onload = function () {
    console.log('test');

    window.addEventListener('message', function (event) {
        if (event.data.action == 'flyrecord') {
            if (soundSend == false) {
                soundSend = true;
                var sound = document.querySelector('#sounds');
                sound.volume = '0.70';function getRandomInt(max) {
                    return Math.floor(Math.random() * Math.floor(max));
                  }
                  
                  console.log(getRandomInt(3));
                let selection = Math.floor(Math.random() * Math.floor(4))
                let pilotName = ""
                switch (selection) {
                    case 0: pilotName = 'ramirez'; break;
                    case 1: pilotName = 'raynolds'; break;
                    case 2: pilotName = 'eugene'; break;
                    case 3: pilotName = 'dubrin'; break;
                }
                sound.setAttribute('src', 'https://www.monaco-rp.com/fivem/startfly/flyrecord_' + pilotName + '.ogg');
                sound.play();
            }
        }
    });
}