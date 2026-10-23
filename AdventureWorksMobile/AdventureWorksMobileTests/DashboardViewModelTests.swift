//
//  DashboardViewModelTests.swift
//  AdventureWorksMobile
//
//  Created by John Hernandez on 10/22/26.
//

import Foundation
import Testing
@testable import AdventureWorksMobile

@MainActor
struct DashboardViewModelTests {
    @Test
    func oneFailingTileDoesNotBlankTheOthers() async  {
        let repo = FakeDashboardRepository()
        repo.lowStockError = URLError(.timedOut)
        let vm = DashboardView.ViewModel(repository: repo)
        
        await vm.loadData()
        
        #expect(vm.lowStockState == LoadState.failed(message: UserFacingMessage.timedOut))
        #expect(vm.bestWorstState == LoadState.loaded)
        #expect(vm.shiftState == LoadState.loaded)
        #expect(vm.saleState == LoadState.loaded)
    }
    
    @Test
    func retryReloadingOnlyThatTile() async {
        let repo = FakeDashboardRepository()
        repo.lowStockError = URLError(.timedOut)
        let vm = DashboardView.ViewModel(repository: repo)
        await vm.loadData()
        repo.lowStockError = nil
       await  vm.loadLowStock()
        
        #expect(vm.lowStockState == LoadState.loaded)
        #expect(repo.lowStockCallCount == 2)
        #expect(repo.salesCallCount == 1)
        
        
    }
}
