classdef mainapp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        TabGroup                       matlab.ui.container.TabGroup
        OptionDataTab                  matlab.ui.container.Tab
        spotprice                      matlab.ui.control.Label
        CurrentSpotPriceLabel          matlab.ui.control.Label
        stocklabel                     matlab.ui.control.Label
        TickerLabel                    matlab.ui.control.Label
        ClickHeretoBeginButton         matlab.ui.control.Button
        UIAxes_3                       matlab.ui.control.UIAxes
        UIAxes_2                       matlab.ui.control.UIAxes
        UIAxes                         matlab.ui.control.UIAxes
        ImpliedVolatilityStructureTab  matlab.ui.container.Tab
        NearexpvolatilityskewLabel     matlab.ui.control.Label
        UITable                        matlab.ui.control.Table
        stocklabel_2                   matlab.ui.control.Label
        TickerLabel_2                  matlab.ui.control.Label
        UIAxes4                        matlab.ui.control.UIAxes
        UIAxes3                        matlab.ui.control.UIAxes
        UIAxes2                        matlab.ui.control.UIAxes
        GammaExposureTab               matlab.ui.container.Tab
        stocklabel_3                   matlab.ui.control.Label
        TickerLabel_3                  matlab.ui.control.Label
        UIAxes5_2                      matlab.ui.control.UIAxes
        UIAxes5                        matlab.ui.control.UIAxes
    end


    properties (Access = private)
        DialogApp                   % Dialog box app
        %CurrentTicker = 'SPY';      %to replace currentsize
        %CurrentSize = 35;           % Surface sample size
        CurrentColormap = 'Parula'; % Colormap
        
    end
    
    properties (Access = public)
        CurrentTicker
    end

    methods (Access = public)
    
        function updateplot(app, ticker)
            app.stocklabel.Text = ticker;
            app.stocklabel_2.Text = ticker;
            app.stocklabel_3.Text = ticker;
            % Store inputs as properties
            %app.CurrentTicker = ticker;
            %app.CurrentColormap = c;
            %app.TickerEditField.Value = char(ticker);
            
            % Update plot1, volume vs strikes
            poopdata = YahOptData(ticker);
            %below pulls the spot price and assigns it to a labek
            app.spotprice.Text = num2str((extractfield(poopdata.optionChain.result.quote, 'bid') + extractfield(poopdata.optionChain.result.quote, 'ask'))/2);

            z = evalOptData(poopdata, 'calls', 'volume');
            %zx = z(:,1);
            %zy = z(:,2);
            histdata = freqdist2histarr(z);
            %Z = peaks(sz);
            %plot(app.UIAxes,zx, zy);
            %colormap(app.UIAxes, "colorcube");
            histogram(app.UIAxes, histdata, 'Normalization','pdf', 'DisplayStyle','bar');
            hold(app.UIAxes, 'on');
            %below is the same function for puts;
            y = evalOptData(poopdata, 'puts', 'volume');
            histpdata = freqdist2histarr(y);
            histogram(app.UIAxes, histpdata, 'Normalization', 'pdf', "DisplayStyle","stairs", "LineWidth", 1.5);
            legend(app.UIAxes, {'Call Volume', 'Put Volume'}, 'Location', "northeast");
            hold(app.UIAxes, 'off');
            
            %Update plot2, openInterest vs strikes
            z1 = evalOptData(poopdata, 'calls', 'openInterest');
            %z1x = z1(:,1);
            %z1y = z1(:,2);
            %Z = peaks(sz);
            %plot(app.UIAxes_2,z1x, z1y);
            %colormap(app.UIAxes_2, "cool");
            histdata2 = freqdist2histarr(z1);
            histogram(app.UIAxes_2, histdata2, 'Normalization','pdf');
            hold(app.UIAxes_2, 'on');
            histpdata2 = freqdist2histarr(evalOptData(poopdata, 'puts', 'openInterest'));
            histogram(app.UIAxes_2, histpdata2, 'Normalization',"pdf", 'DisplayStyle',"stairs", "LineWidth",1.5);
            legend(app.UIAxes_2, {'Call Open Interest', 'Put Open Interest'}, 'Location', "northeast");
            hold(app.UIAxes_2, 'off');
            
            %Update plot3, over/underpricing of long options vs
            %black-scholes model pricing
            % please note that this over/under is somewhat buggy. I think
            % the indices might be off as the calls are very overpriced,
            % whereas the puts are not. If not accounting for skew, then
            % the put 
            z2 = theoPrices(poopdata);
            %z2 = theoVsprice(poopdata, 'calls');
            %zz2 = theoVsprice(poopdata, 'puts');
            z2x = z2(:,1);%strikes
            z2y = z2(:,2);%over/under of calls
            z2z = z2(:,3);%over/under of puts
            %zz2x = zz2(:,1);%strikes again
            %zz2y = zz2(:,2);%over/under of puts
            %Z = peaks(sz);
            plot(app.UIAxes_3,z2x, z2y);
            %colormap(app.UIAxes_3, "cool");
            hold(app.UIAxes_3, 'on');
            plot(app.UIAxes_3, z2x, z2z, 'Color', 'r')
            hold(app.UIAxes_3, 'off');
            
            
            % Re-enable the Plot Options button
            app.ClickHeretoBeginButton.Enable = 'on';
            
            %update plot4, i.e. Ivol term structure
            
            [h1, h2, h3, h4] = IVPlot(multitermData(ticker));
            plot(app.UIAxes2, h1(:,1), smooth(h1(:,2)));
            hold(app.UIAxes2, 'on')
            plot(app.UIAxes2, h2(:,1), smooth(h2(:,2)));
            plot(app.UIAxes2, h3(:,1), smooth(h3(:,2)));
            plot(app.UIAxes2, h4(:,1), smooth(h4(:,2)));
            legend(app.UIAxes2,{'2021-07-16','2021-09-17', '2021-08-20', '2021-11-19'},'Location','east'); 
            hold(app.UIAxes2, 'off')
            
            %update plot5, i.e Ivol term structure (from puts)
            plot(app.UIAxes3, h1(:,1), smooth(h1(:,3)));
            hold(app.UIAxes3, 'on')
            plot(app.UIAxes3, h2(:,1), smooth(h2(:,3)));
            plot(app.UIAxes3, h3(:,1), smooth(h3(:,3)));
            plot(app.UIAxes3, h4(:,1), smooth(h4(:,3)));
            legend(app.UIAxes3,{'2021-07-16','2021-09-17', '2021-08-20', '2021-11-19'},'Location','east'); 
            hold(app.UIAxes3, 'off')
            
            %update plot6, i.e.        
            termdates = {'2021-07-16','2021-08-20', '2021-09-17', '2021-11-19'};
            termdates = datetime(termdates, 'InputFormat',"yyyy-MM-dd");
            %order is out with output so have to swap h3 and h2 places
            atm_calliv = [h1(12,2),h3(12,2),h2(12,2),h4(12,2)];
            atm_putiv = [h1(12,3),h3(12,3),h2(12,3),h4(12,3)];
            plot(app.UIAxes4, termdates, atm_calliv, 'o-','linewidth',2,'markersize',5,'markerfacecolor','b');
            hold(app.UIAxes4, 'on')
            plot(app.UIAxes4, termdates, atm_putiv, 'o-','linewidth',2,'markersize',5,'markerfacecolor','r');
            legend(app.UIAxes4,{'ATM calls', 'ATM puts'},'Location','east'); 
            hold(app.UIAxes4, 'off')
           
            
            %for skew table
            ivcall = h1(:,2);
            ivput = h1(:,3);
            ivskew = ivcall - ivput;
            skewtable = table(h1(:,1), ivcall, ivput, ivskew);
            app.UITable.Data = skewtable;
            
            %Update plot5, GEX(gamma exposure)
            gammaex = GammaEx(poopdata);
            plot(app.UIAxes5, gammaex(:,1), gammaex(:,3), 'o-','linewidth',1.4,'markersize',1,'markerfacecolor','r');
            hold(app.UIAxes5, 'on');
            plot(app.UIAxes5, gammaex(:,1), -gammaex(:,4), 'o-','linewidth',1.4,'markersize',1,'markerfacecolor','b');
            plot(app.UIAxes5, gammaex(:,1), gammaex(:,2), 'o-','linewidth',1.4,'markersize',1,'markerfacecolor','auto');            
            legend(app.UIAxes5, {'Call GEX', 'Put GEX', 'Net GEX'}, "Location","northeast")
            hold(app.UIAxes5, 'off');
           
            %Update plot6, GEX histogram
            netgamma = gammaex(:,[1,2]);
            gammahist = freqdist2histarr(netgamma);
            histogram(app.UIAxes5_2, gammahist, 'Normalization','pdf');
            legend(app.UIAxes5_2, {'Gamma Exposure Histogram'}, 'Location', "northeast");
            
            
        end
        
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Call updateplot to display an initial plot
            app.CurrentTicker = 'SPY';
            updateplot(app, app.CurrentTicker)
        end

        % Button pushed function: ClickHeretoBeginButton
        function ClickHeretoBeginButtonPushed(app, event)
            % Disable Plot Options button while dialog is open
            app.ClickHeretoBeginButton.Enable = 'off';
            
            % Open the options dialog and pass inputs
            app.DialogApp = dialogapp(app);
        end

        % Close request function: UIFigure
        function MainAppCloseRequest(app, event)
            % Delete both apps
            delete(app.DialogApp)
            delete(app)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1259 763];
            app.UIFigure.Name = 'Display Plot';
            app.UIFigure.Resize = 'off';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @MainAppCloseRequest, true);

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 1259 763];

            % Create OptionDataTab
            app.OptionDataTab = uitab(app.TabGroup);
            app.OptionDataTab.Title = 'Option Data';

            % Create UIAxes
            app.UIAxes = uiaxes(app.OptionDataTab);
            title(app.UIAxes, 'Volume vs Strike')
            xlabel(app.UIAxes, 'Strike')
            ylabel(app.UIAxes, {'Normalized Freq. of Total Volume'; ''})
            app.UIAxes.Position = [46 377 541 308];

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.OptionDataTab);
            title(app.UIAxes_2, 'OpenInterest vs Strike')
            xlabel(app.UIAxes_2, 'Strike')
            ylabel(app.UIAxes_2, {'Normalized freq. of '; 'Open Interest'})
            app.UIAxes_2.Position = [657 377 548 313];

            % Create UIAxes_3
            app.UIAxes_3 = uiaxes(app.OptionDataTab);
            title(app.UIAxes_3, 'Overpriced/Underpriced')
            xlabel(app.UIAxes_3, 'Strike')
            ylabel(app.UIAxes_3, 'Premium vs Theoretical value')
            app.UIAxes_3.XLimitMethod = 'padded';
            app.UIAxes_3.YLimitMethod = 'padded';
            app.UIAxes_3.XGrid = 'on';
            app.UIAxes_3.XMinorGrid = 'on';
            app.UIAxes_3.YGrid = 'on';
            app.UIAxes_3.YMinorGrid = 'on';
            app.UIAxes_3.GridAlpha = 0.15;
            app.UIAxes_3.Position = [46 34 1159 269];

            % Create ClickHeretoBeginButton
            app.ClickHeretoBeginButton = uibutton(app.OptionDataTab, 'push');
            app.ClickHeretoBeginButton.ButtonPushedFcn = createCallbackFcn(app, @ClickHeretoBeginButtonPushed, true);
            app.ClickHeretoBeginButton.Position = [570 699 119 22];
            app.ClickHeretoBeginButton.Text = 'Click Here to Begin';

            % Create TickerLabel
            app.TickerLabel = uilabel(app.OptionDataTab);
            app.TickerLabel.FontWeight = 'bold';
            app.TickerLabel.Position = [36 699 45 22];
            app.TickerLabel.Text = 'Ticker:';

            % Create stocklabel
            app.stocklabel = uilabel(app.OptionDataTab);
            app.stocklabel.Position = [76 699 79 22];
            app.stocklabel.Text = '';

            % Create CurrentSpotPriceLabel
            app.CurrentSpotPriceLabel = uilabel(app.OptionDataTab);
            app.CurrentSpotPriceLabel.FontWeight = 'bold';
            app.CurrentSpotPriceLabel.Position = [196 699 115 22];
            app.CurrentSpotPriceLabel.Text = 'Current Spot Price:';

            % Create spotprice
            app.spotprice = uilabel(app.OptionDataTab);
            app.spotprice.Position = [310 699 86 22];
            app.spotprice.Text = '';

            % Create ImpliedVolatilityStructureTab
            app.ImpliedVolatilityStructureTab = uitab(app.TabGroup);
            app.ImpliedVolatilityStructureTab.Title = 'Implied Volatility Structure';

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.ImpliedVolatilityStructureTab);
            title(app.UIAxes2, 'Vol Structure')
            xlabel(app.UIAxes2, 'Strike')
            ylabel(app.UIAxes2, 'Implied Volatility')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [41 488 758 202];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.ImpliedVolatilityStructureTab);
            title(app.UIAxes3, 'Put Vol Structure')
            xlabel(app.UIAxes3, 'Strike')
            ylabel(app.UIAxes3, 'Implied Volatility')
            zlabel(app.UIAxes3, 'Z')
            app.UIAxes3.Position = [41 268 758 205];

            % Create UIAxes4
            app.UIAxes4 = uiaxes(app.ImpliedVolatilityStructureTab);
            title(app.UIAxes4, 'ATM Straddle term structure')
            xlabel(app.UIAxes4, 'Expiration')
            ylabel(app.UIAxes4, 'Implied Volatility')
            zlabel(app.UIAxes4, 'Z')
            app.UIAxes4.Position = [41 34 758 210];

            % Create TickerLabel_2
            app.TickerLabel_2 = uilabel(app.ImpliedVolatilityStructureTab);
            app.TickerLabel_2.Position = [36 699 41 22];
            app.TickerLabel_2.Text = 'Ticker:';

            % Create stocklabel_2
            app.stocklabel_2 = uilabel(app.ImpliedVolatilityStructureTab);
            app.stocklabel_2.Position = [76 699 58 22];
            app.stocklabel_2.Text = '';

            % Create UITable
            app.UITable = uitable(app.ImpliedVolatilityStructureTab);
            app.UITable.ColumnName = {'Strike'; 'IV(call)'; 'IV(put)'; 'Skew'};
            app.UITable.RowName = {};
            app.UITable.ColumnSortable = [true false false true];
            app.UITable.Position = [849 209 356 476];

            % Create NearexpvolatilityskewLabel
            app.NearexpvolatilityskewLabel = uilabel(app.ImpliedVolatilityStructureTab);
            app.NearexpvolatilityskewLabel.Position = [960 699 133 22];
            app.NearexpvolatilityskewLabel.Text = 'Near-exp volatility skew';

            % Create GammaExposureTab
            app.GammaExposureTab = uitab(app.TabGroup);
            app.GammaExposureTab.Title = 'Gamma Exposure';

            % Create UIAxes5
            app.UIAxes5 = uiaxes(app.GammaExposureTab);
            title(app.UIAxes5, 'Gamma Exposure distribution')
            xlabel(app.UIAxes5, 'Strikes')
            ylabel(app.UIAxes5, 'Market Gamma exposure')
            zlabel(app.UIAxes5, 'Z')
            app.UIAxes5.Position = [46 377 1159 323];

            % Create UIAxes5_2
            app.UIAxes5_2 = uiaxes(app.GammaExposureTab);
            title(app.UIAxes5_2, 'Gamma weight histogram')
            xlabel(app.UIAxes5_2, 'Strikes')
            ylabel(app.UIAxes5_2, 'Gamma Weight (Net)')
            zlabel(app.UIAxes5_2, 'Z')
            app.UIAxes5_2.Position = [46 0 1159 323];

            % Create TickerLabel_3
            app.TickerLabel_3 = uilabel(app.GammaExposureTab);
            app.TickerLabel_3.Position = [36 699 41 22];
            app.TickerLabel_3.Text = 'Ticker:';

            % Create stocklabel_3
            app.stocklabel_3 = uilabel(app.GammaExposureTab);
            app.stocklabel_3.Position = [76 699 58 22];
            app.stocklabel_3.Text = '';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = mainapp_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end