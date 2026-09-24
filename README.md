# Nexora — catalogue personnel connecté

Nexora est un **catalogue personnel** : tu es le seul à publier. Les visiteurs consultent les offres immobilières, les voitures et les chiens, regardent les photos ou vidéos, puis te contactent.

## Fichiers principaux

- `index.html` : catalogue public.
- `admin-production.html` : espace d'administration connecté à Supabase.
- `admin.html` : ancienne démo locale avec `localStorage` ; elle peut être gardée pour tester hors connexion, mais la version à utiliser est `admin-production.html`.
- `supabase/schema.sql` : tables, sécurité et bucket images/vidéos.
- `supabase-config.example.js` : modèle de configuration.
- `supabase-config.js` : configuration locale à remplir avec l'URL du projet et la clé `anon` publique.
- `reseaux-sociaux.md` : contenu Facebook et TikTok.

## Architecture choisie

- **Supabase** : compte administrateur, base de données PostgreSQL, stockage des photos et vidéos.
- **Vercel** : déploiement du site.
- **Visiteurs** : lecture uniquement des publications avec le statut `Disponible`.
- **Administrateur** : connexion privée pour ajouter, modifier ou supprimer les publications.

## Mise en place Supabase

1. Crée un projet sur Supabase.
2. Dans **SQL Editor**, colle le contenu de `supabase/schema.sql` et exécute-le.
3. Dans **Authentication > Users**, crée ton compte administrateur avec ton email et un mot de passe fort.
4. Dans **Project Settings > API**, copie :
   - `Project URL` ;
   - `anon public key`.
5. Mets ces deux valeurs dans `supabase-config.js` :

```js
window.NEXORA_CONFIG = {
  url: 'https://TON-PROJET.supabase.co',
  anonKey: 'TA_CLE_ANON_PUBLIQUE'
};
```

Ne mets jamais la clé `service_role` dans le site ou dans un fichier envoyé au navigateur.

## Utilisation de l'administration

Ouvre `admin-production.html`, connecte-toi avec ton compte Supabase, puis ajoute :

- catégorie ;
- ville ou quartier ;
- titre ;
- prix ;
- description ;
- plusieurs images ;
- une vidéo facultative ;
- statut : disponible, réservé, vendu ou brouillon.

Une publication en statut **Disponible** apparaît dans le catalogue public. Une publication réservée, vendue ou en brouillon n'apparaît pas aux visiteurs.

## Déploiement Vercel

Le projet est composé de pages statiques et peut être déployé directement sur Vercel :

1. crée un dépôt GitHub avec les fichiers du projet ;
2. importe le dépôt dans Vercel ;
3. choisis un projet sans commande de build, puisque les pages sont statiques ;
4. vérifie que `supabase-config.js` contient bien l'URL et la clé `anon` publique ;
5. déploie ;
6. ouvre `https://ton-domaine.vercel.app/admin-production.html` pour administrer le catalogue.

Pour un vrai site, ne publie pas de lien vers `admin-production.html` dans le menu client. La protection principale est la connexion Supabase. On pourra ensuite ajouter une restriction de domaine, une URL d'administration moins évidente et une vérification que ton seul compte a les droits d'administration.

## Coordonnées à remplacer

Dans `index.html`, remplace :

- `2250700000000` par ton vrai numéro WhatsApp au format international, sans `+` ni espaces ;
- `bonjour@nexora.ci` par ton email ;
- les liens Facebook et TikTok ;
- le nom `NEXORA` si tu souhaites une autre marque.
