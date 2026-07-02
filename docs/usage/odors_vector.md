[projects](/index.htm)/ [janelia](/janelia/janelia.htm)/

# Odors Vector

```
arena_odors_message.odors = [arm 0 odor, arm 1 odor, arm 2 odor]
```

The three active odors can be represented by a vector, where each element of the
vector represents one of the arms, ARM 0, ARM 1, and ARM 2. Each vector element
can take one of three values, 0, 1, or 2, representing ODOR 0, ODOR 1, or ODOR
2.

## odors = [0, 2, 1]

|       | ODOR 0   | ODOR 1   | ODOR 2   |
|-------|----------|----------|----------|
| ARM 2 | INACTIVE | ACTIVE   | INACTIVE |
| ARM 1 | INACTIVE | INACTIVE | ACTIVE   |
| ARM 0 | ACTIVE   | INACTIVE | INACTIVE |

![img](img/odors_0-2-1.png)

## odors = [0, 0, 0]

|       | ODOR 0 | ODOR 1   | ODOR 2   |
|-------|--------|----------|----------|
| ARM 2 | ACTIVE | INACTIVE | INACTIVE |
| ARM 1 | ACTIVE | INACTIVE | INACTIVE |
| ARM 0 | ACTIVE | INACTIVE | INACTIVE |

![img](img/odors_0-0-0.png)
