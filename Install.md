# Onde Carto Mensuelle
## Guide de déploiement en région 

Ce document décrit étape par étape le déploiement de l'outil **Onde Carto Mensuelle** en se utilisant les services de la plateforme GitHub. La procédure requière uniquement la création d'un compte sur cette plateforme.

## Procédure de déploiement
1. Se connecter à Github
2. Naviguer vers le dépôt https://github.com/richaben/onde_test_regions2
3. Créer une copie du dépôt en cliquant sur le bouton `Fork`.

![image](https://user-images.githubusercontent.com/63242934/225858498-08e36a32-e997-46a1-9a7a-b4ac901ef5e7.png)

   Un formulaire de paramétrage du nouveau dépôt apparaît.

![image](https://user-images.githubusercontent.com/63242934/225859383-d17c852e-efd7-4d0f-8d48-b8e50254048c.png)

4. Renseigner le nom du dépôt `Repository name` sous la forme onde_[libellé de la région]. Exemple : `onde_ile_de_france`
5. Cliquer sur le bouton `Create fork`. Une fois la copie réalisée, le dépôt apparaît dans l'espace de travail de l'utilisateur connecté.

![image](https://user-images.githubusercontent.com/63242934/225859765-787b50a6-4052-4939-81f4-686b20902d45.png)

6. Cliquer sur le script R `01_telechargement_data.R` à la racine du dépôt. Le code R du script apparaît à l'écran.

![image](https://user-images.githubusercontent.com/63242934/225859972-bb39ddc4-8e0c-4a0c-88ef-58bf91c858f3.png)

7. Cliquer sur le bouton `Edit this file`.

![image](https://user-images.githubusercontent.com/63242934/225860270-6bbb8145-701a-4e9d-84bb-4e91a910427b.png)

   Le fichier devient éditable.

![image](https://user-images.githubusercontent.com/63242934/225860409-54f80c47-199d-485d-bbde-90441e317416.png)

8. Rechercher et renseigner la variable `dpt_sel` avec la liste de départements de la région cible. Exemple :
``dpt_sel <- c('75','77','78','91','92', '93', '94', '95') #IDF``

![image](https://user-images.githubusercontent.com/63242934/225860812-75bf8f3d-d58e-4ece-92af-171c73d8f487.png)

9. Dans le panneau `Commit changes` en bas de l'écran, renseigner un libellé et une description (optionnelle) associés à la modification du code. Par exemple :
	Libellé : `Adaptation du traitement à la région Ile de France`
	Description : `Renseignement de la liste des départements concernés`

![image](https://user-images.githubusercontent.com/63242934/225861256-7030dd85-1583-47dd-aadc-5eb58ecc1e06.png)

10. Cliquer sur le bouton `Commit changes` Une fois enregistré, le script réapparaît en lecture seule.
11. Cliquer sur l'élément `<> Code` pour ré afficher la page d'accueil du dépôt.

![image](https://user-images.githubusercontent.com/63242934/225861835-b351760c-85f2-4846-8fe4-088249491240.png)

12. De manière similaire, éditer le fichier `./asset/template.Rmd` et adapter la valeur du champ `author`.

![image](https://user-images.githubusercontent.com/63242934/225862287-9777d9e5-d361-40d6-9fc2-9c5aefd1889e.png)

13. Naviguer vers la page d'accueil du dépôt
15. Cliquer sur le bouton `Settings`.

![image](https://user-images.githubusercontent.com/63242934/225862564-50e94fc0-22f5-4c16-8181-aca4828a9e42.png)

    L'écran de paramétrage du dépôt apparaît.

![image](https://user-images.githubusercontent.com/63242934/225862806-17075088-6dc2-4aa3-8da5-7e7f0e093f17.png)

16. Cliquer sur l'élément `Code and automation > Pages` pour afficher les paramètres du service Github Pages.

![image](https://user-images.githubusercontent.com/63242934/225863116-09b15750-efa3-4981-8c7c-2d58e4b2aebe.png)

17. Dans la section `Branch`, sélectionner `master` et `root` puis cliquer sur le bouton `Save` Le dépôt dispose désormais d'une page web sur Github Pages. Son url est de la forme https://{identifiant de l'utilisateur github}.github.io/onde_{libellé de la région}/
Exemple : https://antonio-andrade.github.io/onde_ile_de_france/
18. Cliquer sur l'élément `Code and automation > Actions > General` pour afficher les paramètres généraux de Github Actions.

![image](https://user-images.githubusercontent.com/63242934/225863546-f344bb11-95e8-4098-bb34-2dfae49bde4c.png)

19. Dans la section `Workflow permissions` en bas de l'écran, sélectionner `Read and write permissions` puis cliquer sur le bouton `Save`.

![image](https://user-images.githubusercontent.com/63242934/225863756-c601b08c-2e04-456e-814f-e826eb4c84a4.png)

20. Afficher de nouveau la page d'accueil du dépôt
21. Cliquer sur le bouton de paramétrage du panneau `About` à droite de l'écran.

![image](https://user-images.githubusercontent.com/63242934/225864049-d19311eb-b750-43c8-b749-907cc745fc90.png)

    Une fenêtre apparaît.

![image](https://user-images.githubusercontent.com/63242934/225864189-1f44d278-7543-4f4d-9266-822b3a977a77.png)

22. Renseigner le champ `Website` avec l'url de la page Github Pages mentionnée ci-dessus puis cliquer sur le bouton `Save changes`. L'url doit apparaître dans le panneau `About`.

![image](https://user-images.githubusercontent.com/63242934/225864721-1529cc65-74c5-45d6-9e51-e3ce7c40ca7d.png)

23. Cliquer sur l'élément `Actions`.

![image](https://user-images.githubusercontent.com/63242934/225865030-ac4677da-987e-453f-8ab3-13a8b045345e.png)

    La liste des flux de travail (workflow) apparaît. Il en existe deux : un premier pour la génération de la page web, un second pour son déploiement sur Github Pages.

![image](https://user-images.githubusercontent.com/63242934/225865213-57920d7d-1b04-4a05-b891-457cecdf6bca.png)

24. Cliquer sur l'item `Script_R_ONDE_carto_auto`. Le paramétrage du flux de travail apparaît.

![image](https://user-images.githubusercontent.com/63242934/225865505-283693ea-88d9-46ed-ad5c-1957395c8872.png)

25. Cliquer sur le bouton `Enable workflow` pour activer le flux de travail.

![image](https://user-images.githubusercontent.com/63242934/225865651-60d69a44-6b0b-4fef-8019-1d107d620c34.png)

    L'écran de lancement du flux de travail apparaît.

![image](https://user-images.githubusercontent.com/63242934/225866110-5627cdcc-06ff-460f-aa9e-7719ea3af637.png)

26. Cliquer sur le bouton `Run workflow` pour lancer l'exécution du flux de travail et confirmer l'opération.

![image](https://user-images.githubusercontent.com/63242934/225866603-fc736f22-c58c-4c3e-af7d-7014ed6c5267.png)

    La génération de la page web est lancée.

![image](https://user-images.githubusercontent.com/63242934/225866779-fb4a14d3-1c22-4131-ba36-71993d2b9498.png)

    Il est possible de suivre l'avancement du traitement en cliquant sur le libellé du flux.

![image](https://user-images.githubusercontent.com/63242934/225866918-38fa86a4-e801-4317-ae52-6bbc311582c5.png)

    Il est également possible de suivvre le détail des traitements en cliquant de nouveau sur le libellé du script R.

![image](https://user-images.githubusercontent.com/63242934/225867577-1426d7ba-43ca-4381-8dc3-a835290dcedd.png)

27. Une fois le flux de travail terminé, naviguer vers la page https://antonio-andrade.github.io/onde_ile_de_france/ La page doit afficher les données de la région cible.

    Une fois ces opérations réalisées, le paramétrage des flux de travail assure l'actualisation de la page chaque matin. Le contenu de la page, sa mise en forme et/ou la fréquence de son actualisation peuvent être librement modifiés.
