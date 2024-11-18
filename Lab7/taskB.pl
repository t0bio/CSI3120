% Task B

% DCG for character description
character_description -->
    character_type(Type),
    character_subtype(Type, _Subtype),
    sequence(_Sequence),
    movement_direction(Type, Weapon, _Direction),
    health_level(_Health),
    weapon(Type, Weapon),
    movement_style(_Style).

% char type
character_type(enemy) --> [enemy].
character_type(hero) --> [hero].

% char subtype
character_subtype(enemy, dark_wizard) --> [dark_wizard].
character_subtype(enemy, demon) --> [demon].
character_subtype(enemy, basilisk) --> [basilisk].
character_subtype(hero, wizard) --> [wizard].
character_subtype(hero, mage) --> [mage].
character_subtype(hero, elf) --> [elf].

% sequence
sequence(Sequence) --> [Sequence], { integer(Sequence), Sequence > 0 }.

%movement
movement_direction(enemy, _, towards) --> [towards].
movement_direction(hero, has_weapon, towards) --> [towards].
movement_direction(hero, no_weapon, away) --> [away].

% health level
health_level(very_weak) --> [very_weak].
health_level(weak) --> [weak].
health_level(normal) --> [normal].
health_level(strong) --> [strong].
health_level(very_strong) --> [very_strong].

% weapon
weapon(enemy, no_weapon) --> [no_weapon].
weapon(hero, has_weapon) --> [has_weapon].
weapon(hero, no_weapon) --> [no_weapon].

% movement style
movement_style(jerky) --> [jerky].
movement_style(stealthy) --> [stealthy].
movement_style(smoothly) --> [smoothly].