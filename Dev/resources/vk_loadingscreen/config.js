/*
    This script was developed by Piter Van Rujpen/TheGamerRespow for Vulkanoa (https://discord.gg/bzMnYPS).
    Do not re-upload this script without my authorization. (I only give authorization by PM on FiveM.net (https://forum.fivem.net/u/TheGamerRespow))
*/


const configuration = {
    staff: [
        {
            head: true,
            name: '🔰 LE STAFF 🔰',
            color: 'rgb(183, 96, 255);',
            members: []
        },
        {
            name: 'Staff Team',
            color: 'rgb(252, 42, 42);',
            members: [
            	'Jimmy Lucchese',
                'Tina Aster',
                'Lucky Luciano',
                'Léo Nopio',
                'Eugène Triboulet'
            ]
        },
        {
            name: 'Dev Team',
            color: 'rgb(0, 231, 0);',
            members: [
            	'Domenico Rossi',
                'Enzo Wizard',
                'Alejandro Luciano Costa'
            ]
        }
    ],
    socialNetworks: [
        {
            icon: 'icon/discord.png',
            text: 'discord.me/NcgY4WZ'
        },
        {
            icon: 'icon/twitter.png',
            text: 'MonacoRolePlay'
        },
        {
            icon: 'icon/facebook.png',
            text: 'Monaco RP'
        },
        {
            icon: 'icon/youtube.png',
            text: 'Monaco RP'
        }
    ],
    musics: [
        {
            file: 'http://radio.monaco-rp.com/radio/8000/radio.mp3',
            title: 'Monaco Radio'
        }/*
        {
            file: 'https://www.monaco-rp.com/fivem/loadingscreen/musiques/old_town_road.ogg',
            title: 'Lil Nas X - Old Town Road (feat. Billy Ray Cyrus) [Remix]'
        },
        {
            file: 'https://www.monaco-rp.com/fivem/loadingscreen/musiques/overworld.ogg',
            title: 'Wubbix - Overworld'
        },
        {
            file: 'https://www.monaco-rp.com/fivem/loadingscreen/musiques/contra_la_pared.ogg',
            title: 'Sean Paul - Contra La Pared (feat. J Balvin)'
        },
        {
            file: 'https://www.monaco-rp.com/fivem/loadingscreen/musiques/my_life_be_like.ogg',
            title: 'L. Starz - My Life Be Like (Grits)'
        },
        {
            file: 'https://www.monaco-rp.com/fivem/loadingscreen/musiques/baila_baila_baila.ogg',
            title: 'Ozuna - Baila Baila Baila'
        },
        {
            file: 'https://www.monaco-rp.com/fivem/loadingscreen/musiques/stay_high.ogg',
            title: 'Tove Lo - Stay High [Hippie Sabotage Remix]'
        },
        {
            file: 'https://www.monaco-rp.com/fivem/loadingscreen/musiques/santiano.ogg',
            title: 'Santiano - Les Marins d\'Iroise'
        },
        {
            file: 'https://www.monaco-rp.com/fivem/loadingscreen/musiques/la_tribue_de_dana.ogg',
            title: 'La tribu de Dana - Manau'
        },
        {
            file: 'https://www.monaco-rp.com/fivem/loadingscreen/musiques/thunder.ogg',
            title: 'Thunder - Imagine Dragons'
        }*/
    ],
    musicVolume: 0.15
};
var VK = new Object(); // DO NOT CHANGE
VK.server = new Object(); // DO NOT CHANGE

VK.backgrounds = new Object(); // DO NOT CHANGE
VK.backgrounds.actual = 0; // DO NOT CHANGE
VK.backgrounds.way = true; // DO NOT CHANGE
VK.config = new Object(); // DO NOT CHANGE
VK.tips = new Object(); // DO NOT CHANGE
VK.info = new Object(); // DO NOT CHANGE
VK.social = new Object(); // DO NOT CHANGE
VK.players = new Object(); // DO NOT CHANGE 

//////////////////////////////// CONFIG

VK.config.loadingSessionText = "Chargement de la session..."; // Loading session text
VK.config.firstColor = [163, 34, 34]; // First color in rgb : [r, g, b]
VK.config.secondColor = [255, 131, 79]; // Second color in rgb : [r, g, b]
VK.config.thirdColor = [52, 152, 219]; // Third color in rgb : [r, g, b]

VK.backgrounds.list = [ // Backgrounds list, can be on local or distant(http://....)
    'https://www.monaco-rp.com/fivem/loadingscreen/images/1.jpg',
    'https://www.monaco-rp.com/fivem/loadingscreen/images/2.jpg',
    'https://www.monaco-rp.com/fivem/loadingscreen/images/3.jpg',
    'https://www.monaco-rp.com/fivem/loadingscreen/images/4.png',
    'https://www.monaco-rp.com/fivem/loadingscreen/images/5.png',
    'https://www.monaco-rp.com/fivem/loadingscreen/images/6.png',
    'https://www.monaco-rp.com/fivem/loadingscreen/images/7.jpg',
    'https://www.monaco-rp.com/fivem/loadingscreen/images/8.jpg',
    'https://www.monaco-rp.com/fivem/loadingscreen/images/9.jpg',
    'https://www.monaco-rp.com/fivem/loadingscreen/images/10.jpg',
    'https://www.monaco-rp.com/fivem/loadingscreen/images/11.jpg',
    'https://www.monaco-rp.com/fivem/loadingscreen/images/12.png'
];
VK.backgrounds.duration = 7000; // Background duration (in ms) before transition (the transition lasts 1/3 of this time)

VK.tips.enable = true; //Enable tips (true : enable, false : prevent)
VK.tips.list = [
    "Appuyez sur \"Y\" pour accèder à votre téléphone",
    "Appuyez sur \"F2\" pour accèder à votre inventaire",
    "Appuyez sur \"F5\" pour accèder à votre menu personel",
    "Appuyez sur \"U\" pour vérouiller ou déverouiller votre véhicule",
    "Appuyez sur \"G\" pour ouvrir votre coffre véhicule",
    "Pour votre bien-être mental, évitez de vous déconnecter avec votre coffre de voiture plein ;)",
    "Tout véhicule abandonné sur la chaussé, même fermé est à même d'être volé !",
];


VK.info.logo = "https://www.monaco-rp.com/fivem/loadingscreen/logo.svg"; // Logo, can be on local or distant(http://....) ("NONE" to desactive)
VK.info.text = "NONE"; // Bottom right corner text ("NONE" to desactive)
VK.info.website = "www.monaco-rp.com"; // Website url ("NONE" to desactive)
VK.info.ip = "54.36.127.17:30120"; // Your server ip and port ("ip:port")

VK.players.enable = true; // Enable the players count of the server (true : enable, false : prevent)
VK.players.multiplePlayersOnline = "@players joueurs en ligne"; // @players equals the players count
VK.players.onePlayerOnline = "1 joueur en ligne"; // Text when only one player is on the server
VK.players.noPlayerOnline = "Aucun joueur en ligne"; // Text when the server is empty

////////////////////////////////
