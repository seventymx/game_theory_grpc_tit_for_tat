/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * Author: Steffen70 <steffen@seventy.mx>
 * Creation Date: 2024-07-25
 *
 * Contributors:
 * - Contributor Name <contributor@example.com>
 */

package server

import (
	"context"

	modelpb "tit_for_tat/generated/model"
	strategypb "tit_for_tat/generated/strategy"
)

type Server struct {
	strategypb.UnimplementedStrategyServer
}

// HandleRequest implements the Tit-for-Tat strategy
func (s *Server) HandleRequest(ctx context.Context, req *strategypb.HandleRequestRequest) (*strategypb.HandleRequestResponse, error) {
	lastOpponentAction := req.GetOpponentAction()
	var action modelpb.PlayerAction

	// Tit-for-Tat logic: cooperate if last action was NONE or COOPERATED, otherwise defect
	if lastOpponentAction == modelpb.OpponentAction_NONE || lastOpponentAction == modelpb.OpponentAction_COOPERATED {
		action = modelpb.PlayerAction_COOPERATE
	} else {
		action = modelpb.PlayerAction_DEFECT
	}

	// Return the player's action in the response
	return &strategypb.HandleRequestResponse{PlayerAction: action}, nil
}
