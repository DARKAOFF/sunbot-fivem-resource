SunBot FiveM Bridge
Ressource FiveM officielle pour connecter un serveur GTA/FiveM au panel SunBot.

Installation
Telecharge le depot en ZIP depuis GitHub.
Renomme le dossier en sunbot-bridge.
Place le dossier dans les resources de ton serveur FiveM.
Ouvre config.lua.
Remplace CHANGE_ME par la cle API affichee dans le module FiveM du panel SunBot.
Configure le framework si necessaire : standalone, esx, qbcore, etc.
Ajoute la ressource dans ton server.cfg.
ensure sunbot-bridge
Configuration
SunBotConfig.ApiUrl = "https://ton-panel.fr/api/fivem"
SunBotConfig.ApiKey = "CLE_API_DU_PANEL"
SunBotConfig.Framework = "standalone"
Si tu reinitalises la cle API depuis le panel SunBot, mets a jour SunBotConfig.ApiKey dans config.lua.

Commande de test
Dans la console serveur FiveM :

sunbot_test
La ressource doit afficher [SunBot] Resource active.
