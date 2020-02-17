/*
    This script was developed by Piter Van Rujpen/TheGamerRespow for Vulkanoa (https://discord.gg/bzMnYPS).
    Do not re-upload this script without my authorization.
*/

$("body").fadeOut(0);


/*
* Chargement du staff et création des éléments
* */
if (configuration.staff != null) {
    let staffElement = document.querySelector("#staff");
    configuration.staff.forEach(category => {
        if (category.members != null) {
            let categoryElement = document.createElement("span");
            categoryElement.classList.add("category");
            categoryElement.innerText = category.name;
            if (category.color != null) {
                categoryElement.style = 'color: ' + category.color;
            }
            if (category.head != null) {
                categoryElement.classList.add('head');
                categoryElement.classList.add('title');
            }
            staffElement.appendChild(categoryElement);
            category.members.forEach(member => {
                let memberElement = document.createElement("span");
                memberElement.classList.add("member");
                memberElement.innerText = member;
                staffElement.appendChild(memberElement);
            })
        }
    });
}

/*
* Chargement des données pour les réseau sociaux (top-bar)
* */
if (configuration.socialNetworks != null) {
    let socialNetworksElement = document.querySelector("#social");
    configuration.socialNetworks.forEach(socialNetwork => {
        let socialNetworkElement = document.createElement("div");
        socialNetworkElement.classList.add("item");
        if (socialNetwork.icon != null) {
            socialNetworkElement.innerHTML = "<div class=\"content\"><img src=\"" + socialNetwork.icon + "\">" + socialNetwork.text + "</div>";
        } else {
            socialNetworkElement.innerHTML = "<div class=\"content\">" + socialNetwork.text + "</div>";
        }
        socialNetworksElement.appendChild(socialNetworkElement);
    });
}

/*
*  Chargement de la musique de chargement
        <div class="title">
            <div class="icon">
                <img src="icon/music.png">
            </div>
            <div class="label">
            </div>
        </div>
* */
if (configuration.musics != null) {
    let musicElement = document.querySelector("#music");
    let currentMusic = configuration.musics[Math.floor(Math.random() * configuration.musics.length)];
    let howl = new Howl({
        src: currentMusic.file,
        autoplay: true,
        loop: true,
        html5: true,
        volume: configuration.musicVolume || 1
    });
    howl.play();
    musicElement.innerHTML = '<div class="title"><div class="icon"><img src="icon/music.png"></div>' +
        '<div class="label">' + currentMusic.title + '</div></div>';
}


if (VK.info.logo !== "NONE") {
    document.querySelector(".logo").innerHTML = "<img src=\"" + VK.info.logo + "\">";
} else {
    document.querySelector(".logo").style.display = "none";
}

if (VK.info.text !== "NONE") {
    document.querySelector(".info .label").innerHTML = VK.info.text;
} else {
    document.querySelector(".info").style.display = "none";
}

if (VK.info.website !== "NONE") {
    document.querySelector(".website .label").innerHTML = VK.info.website;
} else {
    document.querySelector(".website").style.display = "none";
}

if (VK.players.enable === true) {
    $.ajaxSetup({
        crossOrigin: true,
        proxy: "proxy.php"
    });
    $.getJSON("http://runtime.fivem.net/api/servers/", function (data) {
        for (var i = 0; i < data.length; i++) {
            if (data[i]['EndPoint'] == VK.info.ip) {
                VK.server = data[i].Data;
                if (VK.server.players.length > 1) {
                    document.querySelector(".onlinePlayers .label").innerHTML = VK.players.multiplePlayersOnline.replace("@players", VK.server.players.length);
                } else if (VK.server.players.length == 1) {
                    document.querySelector(".onlinePlayers .label").innerHTML = VK.players.onePlayerOnline;
                } else if (VK.server.players.length < 1) {
                    document.querySelector(".onlinePlayers .label").innerHTML = VK.players.noPlayerOnline;
                }
            }
        }
    });
} else {
    document.querySelector(".onlinePlayers").style.display = "none";
}

function getRandomArbitrary(min, max) {
    return Math.random() * (max - min) + min;
}

VK.tips.change = function () {
    setTimeout(function () {
        let newPosition = Math.round(getRandomArbitrary(0, VK.tips.list.length - 1));
        while (newPosition == VK.tips.actual) {
            newPosition = Math.round(getRandomArbitrary(0, VK.tips.list.length - 1));
        }
        VK.tips.actual = newPosition;

        if (document.querySelector(".tip .label").innerHTML == VK.config.loadingSessionText) return;

        document.querySelector(".tip .label").innerHTML = VK.tips.list[VK.tips.actual];
        $(".tip .label").fadeIn(500);
        setTimeout(function () {
            $(".tip .label").fadeOut(500);
            VK.tips.change();
        }, VK.backgrounds.duration - 500)
    }, 500)

};

$(".backgroundTwo").css('background-image', 'url("' + VK.backgrounds.list[Math.round(getRandomArbitrary(0, VK.backgrounds.list.length - 1))] + '")');
VK.backgrounds.change = function () {
    setTimeout(function () {
        let newPosition = Math.round(getRandomArbitrary(0, VK.backgrounds.list.length - 1));
        while (newPosition === VK.backgrounds.actual) {
            newPosition = Math.round(getRandomArbitrary(0, VK.backgrounds.list.length - 1));
        }
        VK.backgrounds.actual = newPosition;

        if (VK.backgrounds.way) {
            $(".backgroundOne").css('background-image', 'url("' + VK.backgrounds.list[VK.backgrounds.actual] + '")');
            $(".backgroundTwo").fadeOut(VK.backgrounds.duration / 3);
        } else {
            $(".backgroundTwo").css('background-image', 'url("' + VK.backgrounds.list[VK.backgrounds.actual] + '")');
            $(".backgroundTwo").fadeIn(VK.backgrounds.duration / 3);
        }
        VK.backgrounds.way = !VK.backgrounds.way;
        VK.backgrounds.change();
    }, VK.backgrounds.duration)
};

VK.backgrounds.change();

if (VK.tips.enable) {
    VK.tips.change();
} else {
    document.querySelector(".tip").style.display = "none";
}

// Color changes

document.querySelector("#music .title").style.borderLeft = "5px solid rgb(" + VK.config.firstColor[0] + "," + VK.config.firstColor[1] + "," + VK.config.firstColor[2] + ")";
document.querySelector(".website").style.borderLeft = "5px solid rgb(" + VK.config.firstColor[0] + "," + VK.config.firstColor[1] + "," + VK.config.firstColor[2] + ")";
document.querySelector(".info").style.borderRight = "5px solid rgb(" + VK.config.secondColor[0] + "," + VK.config.secondColor[1] + "," + VK.config.secondColor[2] + ")";
document.querySelector(".tip").style.borderLeft = "5px solid rgb(" + VK.config.firstColor[0] + "," + VK.config.firstColor[1] + "," + VK.config.firstColor[2] + ")";
document.querySelector(".loading1").style.borderTopColor = "rgb(" + VK.config.firstColor[0] + "," + VK.config.firstColor[1] + "," + VK.config.firstColor[2] + ")";
document.querySelector(".loading2").style.borderTopColor = "rgb(" + VK.config.secondColor[0] + "," + VK.config.secondColor[1] + "," + VK.config.secondColor[2] + ")";
document.querySelector(".loading3").style.borderTopColor = "rgb(" + VK.config.thirdColor[0] + "," + VK.config.thirdColor[1] + "," + VK.config.thirdColor[2] + ")";

$("body").fadeIn(1000);