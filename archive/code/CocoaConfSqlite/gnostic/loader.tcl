package require sqlite3

sqlite3 db "gnostic.sqlite"

db eval {create virtual table graphs using fts4(tokenize=porter,id,graph)}

set gid 1
set ggraph {Hermes: With Reason (Logos), not with hands, did the World-maker make the universal World; so that thou shouldst think of him as everywhere and ever-being, the Author of all things, and One and Only, who by His Will all beings hath created.

    This Body of Him is a thing no man can touch, or see, or measure, a body inextensible, like to no other frame. 'Tis neither Fire nor Water, Air nor Breath; yet all of them come from it. Now being Good he willed to consecrate this [Body] to Himself alone, and set its Earth in order and adorn it.}

db eval {insert into graphs values($gid,$ggraph) }

set gid 2
set ggraph {So down [to Earth] He sent the Cosmos of this Frame Divine - man, a life that cannot die, and yet a life that dies. And o'er [all other] lives and over Cosmos [too], did man excel by reason of the Reason (Logos) and the Mind. For contemplator of God's works did man become; he marvelled and did strive to know their Author.}

db eval {insert into graphs values($gid,$ggraph) }

set gid 3
set ggraph {Reason (Logos) indeed, O Tat, among all men hath He distributed, but Mind not yet; not that He grudgeth any, for grudging cometh not from Him, but hath its place below, within the souls of men who have no Mind.

Tat: Why then did God, O father, not on all bestow a share of Mind?

    H: He willed, my son, to have it set up in the midst for souls, just as it were a prize.}

db eval {insert into graphs values($gid,$ggraph) }

set gid 4

set ggraph {T: And where hath He set it up?

H: He filled a mighty Cup with it, and sent it down, joining a Herald [to it], to whom He gave command to make this proclamation to the hearts of men:

Baptize thyself with this Cup's baptism, what heart can do so, thou that hast faith thou canst ascend to him that hath sent down the Cup, thou that dost know for what thoudidst come into being!

As many then as understood the Herald's tidings and doused themselves in Mind, became partakers in the Gnosis; and when they had "received the Mind" they were made "perfect men".

But they who do not understand the tidings, these, since they possess the aid of Reason [only] and not Mind, are ignorant wherefor they have come into being and whereby.}

db eval {insert into graphs values($gid,$ggraph) }

set gid 5

set ggraph {The senses of such men are like irrational creatures'; and as their [whole] make-up is in their feelings and their impulses, they fail in all appreciation of <lit.: "they do not wonder at"> those things which really are worth contemplation. These center all their thought upon the pleasures of the body and its appetites, in the belief that for its sake man hath come into being.

    But they who have received some portion of God's gift, these, Tat, if we judge by their deeds, have from Death's bonds won their release; for they embrace in their own Mind all things, things on the earth, things in the heaven, and things above the heaven - if there be aught. And having raised themselves so far they sight the Good; and having sighted it, they look upon their sojourn here as a mischance; and in disdain of all, both things in body and the bodiless, they speed their way unto that One and Only One.}

db eval {insert into graphs values($gid,$ggraph) }

set gid 6

set ggraph {This is, O Tat, the Gnosis of the Mind, Vision of things Divine; God-knowledge is it, for the Cup is God's.

T: Father, I, too, would be baptized.

H: Unless thou first shall hate thy Body, son, thou canst not love thy Self. But if thou lov'st thy Self thou shalt have Mind, and having Mind thou shalt share in the Gnosis.

T: Father, what dost thou mean?

H: It is not possible, my son, to give thyself to both - I mean to things that perish and to things divine. For seeing that existing things are twain, Body and Bodiless, in which the perishing and the divine are understood, the man who hath the will to choose is left the choice of one or the other; for it can never be the twain should meet. And in those souls to whom the choice is left, the waning of the one causes the other's growth to show itself.
}

db eval {insert into graphs values($gid,$ggraph) }

set gid 7

set ggraph {Now the choosing of the Better not only proves a lot most fair for him who makes the choice, seeing it makes the man a God, but also shows his piety to God. Whereas the [choosing] of the Worse, although it doth destroy the "man", it doth only disturb God's harmony to this extent, that as processions pass by in the middle of the way, without being able to do anything but take the road from others, so do such men move in procession through the world led by their bodies' pleasures.}

db eval {insert into graphs values($gid,$ggraph) }

set gid 8

set ggraph {This being so, O Tat, what comes from God hath been and will be ours; but that which is dependent on ourselves, let this press onward and have no delay, for 'tis not God, 'tis we who are the cause of evil things, preferring them to good.

Thou see'st, son, how many are the bodies through which we have to pass, how many are the choirs of daimones, how vast the system of the star-courses [through which our Path doth lie], to hasten to the One and Only God.

For to the Good there is no other shore; It hath no bounds; It is without an end; and for Itself It is without beginning, too, though unto us it seemeth to have one - the Gnosis.}

db eval {insert into graphs values($gid,$ggraph) }
set gid 9

set ggraph {Therefore to It Gnosis is no beginning; rather is it [that Gnosis doth afford] to us the first beginning of its being known.

Let us lay hold, therefore, of the beginning. and quickly speed through all [we have to pass].

`Tis very hard, to leave the things we have grown used to, which meet our gaze on every side, and turn ourselves back to the Old Old [Path].

Appearances delight us, whereas things which appear not make their believing hard.

Now evils are the more apparent things, whereas the Good can never show Itself unto the eyes, for It hath neither form nor figure.

Therefore the Good is like Itself alone, and unlike all things else; or `tis impossible that That which hath no body should make Itself apparent to a body.}

db eval {insert into graphs values($gid,$ggraph) }
set gid 10

set ggraph { The "Like's" superiority to the "Unlike" and the "Unlike's" inferiority unto the "Like" consists in this:

The Oneness being Source and Root of all, is in all things as Root and Source. Without [this] Source is naught; whereas the Source [Itself] is from naught but itself, since it is Source of all the rest. It is Itself Its Source, since It may have no other Source.

The Oneness then being Source, containeth every number, but is contained by none; engendereth every number, but is engendered by no other one.}

db eval {insert into graphs values($gid,$ggraph) }
set gid 11

set ggraph {Now all that is engendered is imperfect, it is divisible, to increase subject and to decrease; but with the Perfect [One] none of these things doth hold. Now that which is increasable increases from the Oneness, but succumbs through its own feebleness when it no longer can contain the One.

    And now, O Tat, God's Image hath been sketched for thee, as far as it can be; and if thou wilt attentively dwell on it and observe it with thine heart's eyes, believe me, son, thou'lt find the Path that leads above; nay, that Image shall become thy Guide itself, because the Sight [Divine] hath this peculiar [charm], it holdeth fast and draweth unto it those who succeed in opening their eyes, just as, they say, the magnet [draweth] iron.}

db eval {insert into graphs(graphs) values('optimize') }
