/* Copyright (c) 2021 vesoft inc. All rights reserved.
 *
 * This source code is licensed under Apache 2.0 License,
 * attached with Common Clause Condition 1.0, found in the LICENSES directory.
 */

#ifndef EXECUTOR_QUERY_LEFTJOINEXECUTOR_H_
#define EXECUTOR_QUERY_LEFTJOINEXECUTOR_H_

#include "executor/query/JoinExecutor.h"

namespace nebula {
namespace graph {

class LeftJoinExecutor final : public JoinExecutor {
public:
    LeftJoinExecutor(const PlanNode *node, QueryContext *qctx)
        : JoinExecutor("LeftJoinExecutor", node, qctx) {}

    folly::Future<Status> execute() override;

    Status close() override;

private:
    folly::Future<Status> join();

    void probe(const std::vector<Expression*>& probeKeys, Iterator* probeiter,
               JoinIter* resultIter);

private:
    size_t rightSize_{0};
};
}  // namespace graph
}  // namespace nebula
#endif
