# Copyright (c) 2021 vesoft inc. All rights reserved.
#
# This source code is licensed under Apache 2.0 License,
# attached with Common Clause Condition 1.0, found in the LICENSES directory.
Feature: Function Call Expression

  Background:
    Given a graph with space named "nba"

  Scenario: sign
    When executing query:
      """
      YIELD sign(38) AS a, sign(-2) AS b, sign(0.421) AS c,
            sign(-1.0) AS d, sign(0) AS e, sign(abs(-3)) AS f
      """
    Then the result should be, in any order:
      | a | b  | c | d  | e | f |
      | 1 | -1 | 1 | -1 | 0 | 1 |

  Scenario: date related
    When executing query:
      """
      YIELD timestamp("2000-10-10T10:00:00") AS a, date() AS b, time() AS c,
            datetime() AS d
      """
    Then the result should be, in any order:
      | a       | b                      | c                            | d                                               |
      | /^\d+$/ | /^\d{4}\-\d{2}-\d{2}$/ | /^\d{2}:\d{2}:\d{2}\.\d{6}$/ | /^\d{4}\-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{6}$/ |

  Scenario: concat
    When executing query:
      """
      GO FROM "Tim Duncan" over like YIELD concat(like._src, $^.player.age, $$.player.name, like.likeness) AS A
      """
    Then the result should be, in any order:
      | A                             |
      | "Tim Duncan42Manu Ginobili95" |
      | "Tim Duncan42Tony Parker95"   |
    When executing query:
      """
      GO FROM "Tim Duncan" over like YIELD concat(like._src, $^.player.age, null, like.likeness) AS A
      """
    Then the result should be, in any order:
      | A    |
      | NULL |
      | NULL |
    When executing query:
      """
      match (a:player)-[b:serve]-(c:team{name: "Lakers"}) where a.age > 45   return  concat(a.name,c.name)
      """
    Then the result should be, in any order:
      | concat(a.name,c.name)   |
      | "Shaquile O'NealLakers" |
    When executing query:
      """
      match (a:player)-[b:serve]-(c:team{name: "Lakers"}) where a.age > 45   return  concat(a.name, "hello")
      """
    Then the result should be, in any order:
      | concat(a.name,c.name)  |
      | "Shaquile O'Nealhello" |

  Scenario: concat_ws
    When executing query:
      """
      GO FROM "Tim Duncan" over like YIELD concat_ws("-",like._src, $^.player.age, $$.player.name, like.likeness) AS A
      """
    Then the result should be, in any order:
      | A                                |
      | "Tim Duncan-42-Manu Ginobili-95" |
      | "Tim Duncan-42-Tony Parker-95"   |
    When executing query:
      """
      match (a:player)-[b:serve]-(c:team{name: "Lakers"}) where a.age > 45   return  concat_ws("@",a.name, "hello", b.likeness, c.name)
      """
    Then the result should be, in any order:
      | concat_ws("@",a.name,"hello",b.likeness,c.name) |
      | "Shaquile O'Neal@hello@Lakers"                  |
    When executing query:
      """
      match (a:player)-[b:serve]-(c:team{name: "Lakers"}) where a.age > 45   return  concat_ws("@",a.name, NULL, "hello", b.likeness, c.name)
      """
    Then the result should be, in any order:
      | concat_ws("@",a.name,"hello",b.likeness,c.name) |
      | "Shaquile O'Neal@hello@Lakers"                  |
