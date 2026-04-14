# Agent business cards

Public JPGs used for MMS attachments in Make.com lead workflows.

Each image is referenced via its public Netlify URL, e.g.
`https://dusefg.netlify.app/cards/mark.jpg`

## Adding a new agent

```bash
cd cards
./make-card.sh path/to/jane-smith.pdf jane-smith
git add cards/jane-smith.jpg
git commit -m "Add jane-smith business card"
git push
```

After Netlify redeploys (~30s), the card is live at
`https://dusefg.netlify.app/cards/jane-smith.jpg` and ready to paste into the
agent's row in the NOVA agents Data Store.

## Image spec

- 1200px wide, progressive JPEG, ~150-200KB
- Under Twilio's 600KB MMS cap by a wide margin
- Stripped of EXIF metadata
