# SunBot FiveM Bridge

Ressource FiveM officielle pour connecter un serveur GTA/FiveM au panel SunBot.

## Ce que fait la ressource

- Envoie un heartbeat au panel SunBot toutes les 30 secondes.
- Remonte le nombre de joueurs connectes.
- Recupere les commandes envoyees depuis le panel.
- Confirme au panel si une commande a reussi ou echoue.
- Fournit une base propre pour brancher ESX, QBCore ou un framework custom.

## Installation

1. Telecharge le ZIP depuis GitHub.
2. Decompresse l'archive.
3. Renomme le dossier en `sunbot-bridge`.
4. Place le dossier dans les `resources` de ton serveur FiveM.
5. Ouvre le module FiveM sur le panel SunBot pour generer la cle API.
6. Ouvre `config.lua`.
7. Remplace `CHANGE_ME` par la cle API affichee dans le module FiveM du panel SunBot.
8. Verifie que l'URL du panel pointe vers `https://sun-bot.fr/api/fivem`.
9. Ajoute la ressource dans ton `server.cfg`.

```cfg
ensure sunbot-bridge
```

## Configuration

```lua
SunBotConfig.ApiUrl = "https://sun-bot.fr/api/fivem"
SunBotConfig.ApiKey = "CLE_API_DU_PANEL"
SunBotConfig.Framework = "standalone"
```

Valeurs possibles pour `SunBotConfig.Framework` :

- `standalone`
- `esx`
- `qbcore`
- `custom`

Si tu reinitalises la cle API depuis le panel SunBot, mets a jour `SunBotConfig.ApiKey` dans `config.lua`.

## Commande de test

Dans la console serveur FiveM :

```text
sunbot_test
```

La ressource doit afficher :

```text
[SunBot] Resource active.
```

Si la console affiche `Bridge not configured`, la cle API n'a pas encore ete remplacee dans `config.lua`.

## Commandes prises en charge

La ressource contient deja une base pour :

- `announce`
- `custom`
- `revive`
- `setjob`
- `additem`

Les commandes `revive`, `setjob` et `additem` sont volontairement laissees en hook a adapter selon ton framework serveur.

## Mise a jour

Pour mettre a jour la ressource :

1. Telecharge la derniere version depuis GitHub.
2. Remplace `server.lua` et `fxmanifest.lua`.
3. Garde ton `config.lua` actuel si ta cle API est deja configuree.
4. Redemarre la ressource.

```cfg
restart sunbot-bridge
```
