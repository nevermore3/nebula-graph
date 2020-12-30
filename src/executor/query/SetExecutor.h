/* Copyright (c) 2020 vesoft inc. All rights reserved.
 *
 * This source code is licensed under Apache 2.0 License,
 * attached with Common Clause Condition 1.0, found in the LICENSES directory.
 */

#ifndef EXECUTOR_QUERY_SETEXECUTOR_H_
#define EXECUTOR_QUERY_SETEXECUTOR_H_

#include <memory>

#include "executor/Executor.h"

namespace nebula {

class Iterator;

namespace graph {

class SetExecutor : public Executor {
public:
    Status checkInputDataSets();
    std::unique_ptr<Iterator> getLeftInputDataIter() const;
    std::unique_ptr<Iterator> getRightInputDataIter() const;

protected:
    SetExecutor(const std::string &name, const PlanNode *node, QueryContext *qctx)
        : Executor(name, node, qctx) {}

private:
    int64_t leftVersion_;
    int64_t rightVersion_;
    std::string leftVar_;
    std::string rightVar_;
};

}   // namespace graph
}   // namespace nebula

#endif   // EXECUTOR_QUERY_SETEXECUTOR_H_
