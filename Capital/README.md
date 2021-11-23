# Capital

Module - https://www.roblox.com/library/8073334886/

A roblox model to help utilize currency OOP in games.

# Documentation

Make sure you have DataStore's enabled so it can save data over servers.

| Property | Type | Description | 
|-|-|-|
| Stores | dictionary | The current loaded capitals in game. |

## Methods

### new(player)

| Parameter | Type | Description | Default |
|-|-|-|-|
| player | Player | The owner of the capital | ✅ |

**Description:** Creates a new capital with the set `player` as the owner.

**Returns:** capital

**Note:** Used for internal use, I suggest `get` instead since that checks if the player has an existing capital.

---

### get(player)

| Parameter | Type | Description | Default |
|-|-|-|-|
| player | Player | The owner of the capital | ✅ |

**Description:** Returns an existing captal owned by the `player`, else uses `new` to create a new one.

**Returns:** capital

---

### draw(owner, value)

| Parameter | Type | Description | Default |
|-|-|-|-|
| owner | Player | The owner of the capital | ✅ |
| value | number | The amount for the new capital | 0 |

**Description:** Returns an existing captal owned by the `player` and with a set value.

**Returns:** capital

**Note:** Used for internal use, I suggest `get` instead.

---
