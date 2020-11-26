/* Copyright (c) 2020 vesoft inc. All rights reserved.
 *
 * This source code is licensed under Apache 2.0 License,
 * attached with Common Clause Condition 1.0, found in the LICENSES directory.
 */

#ifndef EXECUTOR_QUERY_GETVERTICESEXECUTOR_H_
#define EXECUTOR_QUERY_GETVERTICESEXECUTOR_H_

#include "executor/query/GetPropExecutor.h"
#include "planner/Query.h"

namespace nebula {
namespace graph {
class GetVertices;
class GetVerticesExecutor final : public GetPropExecutor {
public:
    GetVerticesExecutor(const PlanNode *node, QueryContext *qctx)
        : GetPropExecutor("GetVerticesExecutor", node, qctx) {}

    folly::Future<Status> execute() override;

    Status close() override;

private:
    DataSet buildRequestDataSet(const GetVertices* gv);

    Status buildVerticesRequestDataSet();
    Status buildPathRequestDataSet();
    folly::Future<Status> getVertices();
    folly::Future<Status> getPathVertices();

private:
    DataSet               reqDs_;
    DataSet               pathsDs_;
    const GetVertices*    gv_;
};

}   // namespace graph
}   // namespace nebula

#endif   // EXECUTOR_QUERY_GETVERTICESEXECUTOR_H_
